#!/usr/bin/env bash
# Copyright 2026 Innodisk Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Start the iQ-Studio GenieX VLM Demo container on this Qualcomm IQ9.
#
#   docker/docker_run.sh [<image>] [--mode vlm|chat] [--runtime R] [--backend B]
#
# This is also iQ-Studio's tutorials/applications/iqs-vlm/run.sh. iqs-launcher
# calls it with the image it found as the first argument, followed by whatever
# was passed through --other:
#
#   iqs-launcher --autotag iqs-vlm-demo --other "--runtime GenieX-llama.cpp --backend GPU"
#
# So it must stay SELF-CONTAINED: it reads nothing from this repository and
# writes its host state under $IQS_VLM_DATA_DIR. The image carries the
# application and both model bundles.
#
# Runs in the foreground and streams the demo's output. Press q in the desktop
# window (or here, in chat mode), or Ctrl+C here, to stop; both take the
# launcher's ordered shutdown path. The container is removed on exit.
set -euo pipefail

IMAGE="${GENIEX_IMAGE:-innodiskorg/iqs-vlm-demo:latest}"
# The running container's name, not the image: Docker forbids '/' here.
CONTAINER="iqs-vlm-demo"
# Where docker/entrypoint.sh writes the launch configuration, on a tmpfs.
CONFIG_TARGET="/config/config.json"
# Host-side writable state: logs, lifecycle state and the Open WebUI database.
DATA_DIR="${IQS_VLM_DATA_DIR:-/var/lib/iqs-vlm-demo}"
# Must match gateway.port in config/application.yaml, which is baked into the image.
# Open WebUI reaches the gateway through this published port.
GATEWAY_PORT="${GENIEX_GATEWAY_PORT:-8000}"
# The Compose project the image's launcher starts Open WebUI under. Must match
# scripts/start_open_webui.sh and app/common/shutdown.py.
COMPOSE_PROJECT="geniex-vlm-demo"
# The host Docker socket, which chat mode hands to the container so it can start
# Open WebUI as a sibling container on this host.
DOCKER_SOCKET="/var/run/docker.sock"
# The camera is discovered, not hardcoded. The application globs
# /dev/v4l/by-id/*-index0 and takes the first, so every match is mapped here and
# the container's own glob lands on the same device. Only USB devices appear
# under by-id, so the platform ISP and the hardware video codecs are never
# exposed - the device list stays strictly enumerated and unprivileged.
shopt -s nullglob
CAMERAS=(/dev/v4l/by-id/*-index0)
shopt -u nullglob

usage() {
  cat >&2 <<'USAGE'
Usage: docker_run.sh [<image>] [--mode vlm|chat] [--runtime R] [--backend B] [--dry-run]

  <image>        Image to run. Default: innodiskorg/iqs-vlm-demo:latest, or
                 $GENIEX_IMAGE. iqs-launcher always passes it.
  --mode M       vlm   camera desktop with live VLM captions (default)
                 chat  Open WebUI chat interface at http://<device>:3000
  --runtime R    GenieX-Qairt      Qwen3-VL-4B-Instruct, NPU only (default)
                 GenieX-llama.cpp  LFM2.5-VL-450M, NPU, CPU, GPU or Hybrid
  --backend B    NPU (default), CPU, GPU or Hybrid.
  --dry-run      Print the docker run command and exit without starting
                 anything. Useful for checking which optional mounts were
                 detected.
  -h, --help     Show this message.

Through iqs-launcher, pass the options with --other:

  iqs-launcher --autotag iqs-vlm-demo --other "--mode chat --runtime GenieX-llama.cpp --backend GPU"

Host state is kept under $IQS_VLM_DATA_DIR (default /var/lib/iqs-vlm-demo).
USAGE
}

# ---------------------------------------------------------------------------
# Arguments. Unknown arguments are a usage error rather than something silently
# forwarded to docker.
# ---------------------------------------------------------------------------
DRY_RUN=0
MODE="vlm"
RUNTIME="GenieX-Qairt"
BACKEND="NPU"

if (($# > 0)) && [[ "$1" != -* ]]; then
  IMAGE="$1"
  shift
fi

option_value() { # option_value <option> <remaining argument count>
  if (($2 < 2)); then
    echo "option $1 needs a value" >&2
    usage
    exit 2
  fi
}

while (($# > 0)); do
  case "$1" in
    --mode)
      option_value "$1" "$#"
      MODE="$2"
      shift 2
      ;;
    --runtime)
      option_value "$1" "$#"
      RUNTIME="$2"
      shift 2
      ;;
    --backend)
      option_value "$1" "$#"
      BACKEND="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

case "$MODE" in
  vlm | chat) ;;
  *)
    echo "unknown mode: $MODE (choose vlm or chat)" >&2
    exit 2
    ;;
esac
# The runtime and backend are validated inside the container, against the very
# model catalog the image carries, before anything starts.

# ---------------------------------------------------------------------------
# Docker preconditions.
# ---------------------------------------------------------------------------
command -v docker >/dev/null 2>&1 || {
  echo "docker is required but was not found" >&2
  exit 1
}
if ((DRY_RUN == 0)); then
  # iqs-launcher hands over an image it did not find locally or as a .tar and
  # leaves the download to this script, so a missing image is pulled - with a
  # warning first, because it is several gigabytes.
  if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "$IMAGE is not on this device; pulling it (several GB, this can take a while)"
    if ! docker pull "$IMAGE"; then
      echo "could not pull $IMAGE" >&2
      echo "Check the network, or build it on this device with docker/docker_build.sh." >&2
      exit 1
    fi
  fi
  if [[ -n "$(docker ps -aq --filter "name=^${CONTAINER}$")" ]]; then
    echo "a container named $CONTAINER already exists" >&2
    echo "A previous run did not exit cleanly. Remove it with:" >&2
    echo "  docker rm -f $CONTAINER" >&2
    exit 1
  fi
fi

# ---------------------------------------------------------------------------
# Mount and device assembly.
#
# Every bind uses --mount, never -v: -v silently CREATES a missing host path as
# an empty directory, so an absent optional source would leave a stray directory
# on the host where a file belongs. --mount fails instead of creating, so the
# sources are checked here first and reported all at once with a remedy.
# ---------------------------------------------------------------------------
DOCKER_ARGS=()
MISSING_REQUIRED=()
MISSING_IN_GROUP=""

add_mount() { # add_mount <host source> <container target> <ro|rw>
  local spec="type=bind,source=$1,target=$2"
  [[ "$3" == "ro" ]] && spec="$spec,readonly"
  DOCKER_ARGS+=(--mount "$spec")
}

add_device() { # add_device <path>, mapped at the same path inside
  DOCKER_ARGS+=(--device "$1:$1")
}

require() { # require <path...>
  local path
  for path in "$@"; do
    [[ -e "$path" ]] || MISSING_REQUIRED+=("$path")
  done
}

group_available() { # group_available <path...>; records the first absent one
  MISSING_IN_GROUP=""
  local path
  for path in "$@"; do
    if [[ ! -e "$path" ]]; then
      MISSING_IN_GROUP="$path"
      return 1
    fi
  done
  return 0
}

# --- required -------------------------------------------------------------
# The launch configuration is written by the entry point onto a tmpfs that never
# reaches a disk or the container's own writable layer.
DOCKER_ARGS+=(--tmpfs "$(dirname "$CONFIG_TARGET"):mode=0755")

# Qualcomm libraries the vendored runtime reaches through. libcdsprpc and
# libadsprpc are the targets of absolute symlinks inside runtime/geniex/lib, and
# app/common/validate.py refuses to start if either dangles.
require /usr/lib/libcdsprpc.so.1.0.0 /usr/lib/libadsprpc.so.1.0.0 \
  /usr/lib/libyaml-0.so.2.0.9
add_mount /usr/lib/libcdsprpc.so.1.0.0 /usr/lib/libcdsprpc.so.1 ro
add_mount /usr/lib/libadsprpc.so.1.0.0 /usr/lib/libadsprpc.so.1 ro
# QLI 2.0's libcdsprpc NEEDs libyaml-0.so.2, which ubuntu:24.04 does not ship.
# Without it libcdsprpc cannot load and QNN fails with "Failed to create
# device: 14001".
add_mount /usr/lib/libyaml-0.so.2.0.9 /usr/lib/libyaml-0.so.2 ro

# The CDSP's DSP-side binaries. GenieX's FastRPC session loads them from
# /usr/lib/dsp in the container; without this mount QNN fails with the same
# "Failed to create device: 14001". QLI 2.0 keeps them under
# /usr/share/qcom/<DSP_LIBRARY_PATH>/cdsp, where the board's entry in
# /usr/share/qcom/conf.d names DSP_LIBRARY_PATH for its device-tree model.
MACHINE_MODEL="$(tr -d '\0' </proc/device-tree/model 2>/dev/null || true)"
DSP_LIBRARY_PATH=""
if [[ -n "$MACHINE_MODEL" ]]; then
  DSP_LIBRARY_PATH="$(grep -h -A1 -E "^[[:space:]]+\"?${MACHINE_MODEL}\"?:" \
    /usr/share/qcom/conf.d/*.yaml 2>/dev/null |
    sed -n 's/.*DSP_LIBRARY_PATH: *//p' | tr -d '"' | head -1 || true)"
fi
if [[ -z "$DSP_LIBRARY_PATH" ]]; then
  MISSING_REQUIRED+=("/usr/share/qcom/conf.d entry for '${MACHINE_MODEL:-unknown board}'")
else
  CDSP_DIR="/usr/share/qcom/$DSP_LIBRARY_PATH/cdsp"
  require "$CDSP_DIR"
  add_mount "$CDSP_DIR" /usr/lib/dsp ro
fi

# Writable state on the host, so logs survive the container for a bug report.
LOG_DIR="$DATA_DIR/logs"
STATE_DIR="$DATA_DIR/state"
OPEN_WEBUI_DATA="$DATA_DIR/open-webui"
add_mount "$LOG_DIR" /opt/geniex-vlm-demo/runtime/logs rw
add_mount "$STATE_DIR" /opt/geniex-vlm-demo/runtime/state rw

# NPU FastRPC and the DMA-BUF heaps its tensor buffers come from.
require /dev/fastrpc-cdsp /dev/dma_heap/system
add_device /dev/fastrpc-cdsp
add_device /dev/dma_heap/system

if [[ "$MODE" == "vlm" ]]; then
  # The system Weston socket. Not read-only: connect(2) is not a filesystem
  # write, but the toolkit may want to create runtime state alongside it.
  require /run/user/1000/wayland-1
  add_mount /run/user/1000/wayland-1 /run/user/1000/wayland-1 rw

  # The camera. Reported through the same batched check as everything else, so
  # an unplugged camera is listed alongside any other missing path.
  if ((${#CAMERAS[@]} == 0)); then
    MISSING_REQUIRED+=("/dev/v4l/by-id/*-index0 (no USB camera detected)")
  else
    for camera in "${CAMERAS[@]}"; do
      add_device "$camera"
    done
  fi
else
  # Chat mode needs neither the camera nor the display, so a headless unit
  # with nothing attached runs it; the launcher's preflight skips the camera.
  # Open WebUI runs as a sibling container on this host, started through the
  # host's own Docker daemon. That daemon resolves bind sources on the HOST, so
  # the Open WebUI database is mounted at the same absolute path inside the
  # container and Compose is told that path.
  require "$DOCKER_SOCKET"
  add_mount "$DOCKER_SOCKET" "$DOCKER_SOCKET" rw
  add_mount "$OPEN_WEBUI_DATA" "$OPEN_WEBUI_DATA" rw
fi

if ((${#MISSING_REQUIRED[@]} > 0)); then
  echo "cannot start: these required host paths are missing:" >&2
  printf '  %s\n' "${MISSING_REQUIRED[@]}" >&2
  if [[ "$MODE" == "vlm" ]]; then
    echo "" >&2
    echo "An unplugged camera is the usual cause; any USB/UVC camera will do, and" >&2
    echo "it is detected automatically - no configuration needs to name it." >&2
  fi
  exit 1
fi

# --- optional: Adreno GPU --------------------------------------------------
# For the llama.cpp OpenCL backends. The GPU utilization bar does not need it:
# qcperf reads /sys/class/kgsl, which a container can already read.
GPU_PATHS=(
  /dev/kgsl-3d0
  /dev/dri/card0
  /dev/dri/renderD128
  /usr/lib/libGLESv2_adreno.so.2
  /usr/lib/libEGL_adreno.so.1
  /usr/lib/libeglSubDriverWayland.so.1
  /usr/lib/libgsl.so.1
  /usr/lib/libadreno_utils.so.1
  /usr/lib/libllvm-glnext.so.1
)
GPU_AVAILABLE=0
if group_available "${GPU_PATHS[@]}"; then
  GPU_AVAILABLE=1
  add_device /dev/kgsl-3d0
  add_device /dev/dri/card0
  add_device /dev/dri/renderD128
  add_mount /usr/lib/libGLESv2_adreno.so.2 /usr/lib/libGLESv2_adreno.so.2 ro
  add_mount /usr/lib/libEGL_adreno.so.1 /usr/lib/libEGL_adreno.so.1 ro
  add_mount /usr/lib/libeglSubDriverWayland.so.1 /usr/lib/libeglSubDriverWayland.so.1 ro
  add_mount /usr/lib/libgsl.so.1 /usr/lib/libgsl.so.1 ro
  add_mount /usr/lib/libadreno_utils.so.1 /usr/lib/libadreno_utils.so.1 ro
  add_mount /usr/lib/libllvm-glnext.so.1 /usr/lib/libllvm-glnext.so.1 ro
else
  echo "WARNING: the Adreno GPU stack is incomplete ($MISSING_IN_GROUP is missing)." >&2
  echo "         The GPU utilization bar will read N/A, and the llama.cpp GPU and" >&2
  echo "         HYBRID backends will not work. CPU and NPU are unaffected." >&2
fi

# --- optional: qcperf telemetry --------------------------------------------
# runtime/qcperf ships in the image, so nothing is installed on the host. It reads
# the NPU through Sysmon over the secure FastRPC channel. The host libcdsprpc finds
# each DSP's Sysmon skel by matching the board's device-tree model against
# /usr/share/qcom/conf.d, but Docker masks /sys/firmware, so the model is read here
# and handed over; app/telemetry/qcperf.py sets it as MACHINE_NAME for the qcperf
# process only. Without this group the demo runs exactly as well, with the NPU bar
# reading N/A.
QCPERF_PATHS=(
  /usr/share/qcom
  /dev/fastrpc-cdsp-secure
  /proc/device-tree/model
)
QCPERF_MACHINE_NAME=""
if group_available "${QCPERF_PATHS[@]}"; then
  add_mount /usr/share/qcom /usr/share/qcom ro
  add_device /dev/fastrpc-cdsp-secure
  # NPU1 feeds no bar. qcperf samples it anyway and still reports NPU0 without it,
  # so it is mapped only where the board has a second CDSP.
  [[ -e /dev/fastrpc-cdsp1-secure ]] && add_device /dev/fastrpc-cdsp1-secure
  QCPERF_MACHINE_NAME="$MACHINE_MODEL"
else
  echo "WARNING: NPU utilization is unavailable ($MISSING_IN_GROUP is missing)." >&2
  echo "         The NPU bar will read N/A. Everything else, including inference" >&2
  echo "         and the GPU bar, is unaffected." >&2
fi

# --- optional: Adreno OpenCL ----------------------------------------------
# Only the llama.cpp GPU and HYBRID backends need these. Pointless without the
# GPU group above, so it is not even attempted then.
OPENCL_PATHS=(
  /usr/lib/libOpenCL_adreno.so.1
  /usr/lib/libCB.so.1
  /usr/lib/libllvm-qcom.so.1
)
if ((GPU_AVAILABLE == 1)); then
  if group_available "${OPENCL_PATHS[@]}"; then
    add_mount /usr/lib/libOpenCL_adreno.so.1 /usr/lib/libOpenCL_adreno.so.1 ro
    add_mount /usr/lib/libCB.so.1 /usr/lib/libCB.so.1 ro
    # The online kernel compiler; llama.cpp ships its OpenCL kernels as source.
    add_mount /usr/lib/libllvm-qcom.so.1 /usr/lib/libllvm-qcom.so.1 ro
  else
    echo "WARNING: the Adreno OpenCL stack is incomplete ($MISSING_IN_GROUP is missing)." >&2
    echo "         The llama.cpp GPU and HYBRID backends will fail. CPU and NPU are" >&2
    echo "         unaffected." >&2
  fi
fi

# ---------------------------------------------------------------------------
# Runtime settings.
# ---------------------------------------------------------------------------
RUN_ARGS=(
  --rm
  --name "$CONTAINER"
  # tini as PID 1. Required, not cosmetic: start_geniex.sh and start_gateway.sh
  # background their children inside short-lived scripts, so the lifecycle
  # manager and uvicorn are reparented to PID 1 and need reaping.
  --init
  # Makes tini signal the whole process group rather than only its direct child,
  # which is what reproduces a native Ctrl+C: bash defers a trapped signal while
  # its foreground command, the OpenCV desktop, is still running.
  -e TINI_KILL_PROCESS_GROUP=1
  # The selection docker/entrypoint.sh validates and turns into $CONFIG_TARGET.
  -e "GENIEX_MODE=$MODE"
  -e "GENIEX_RUNTIME=$RUNTIME"
  -e "GENIEX_BACKEND=$BACKEND"
  # The Qualcomm root console exports neither of these, and
  # scripts/common.sh::configure_display_environment needs both.
  -e XDG_RUNTIME_DIR=/run/user/1000
  -e WAYLAND_DISPLAY=wayland-1
  # Ubuntu's OpenCV HighGUI is a Qt5 build that defaults to the X11 plugin, and
  # this target runs Weston with no X server.
  -e QT_QPA_PLATFORM=wayland
  # Harmless with Qt, and correct if the image is ever rebuilt against GTK3.
  -e GDK_BACKEND=wayland
  # DISPLAY is deliberately not set: common.sh prefers X11 whenever it is present.
  --stop-signal SIGINT
  # app/common/shutdown.py escalates SIGTERM -> 15 s -> SIGKILL per component and
  # then waits up to 30 s for GenieX to release the accelerator.
  --stop-timeout 120
  --shm-size 256m
  # The gateway binds 0.0.0.0:$GATEWAY_PORT inside; GenieX stays on 127.0.0.1:18181
  # in the container's own namespace and is not published. The gateway does not
  # authenticate: use 127.0.0.1:$GATEWAY_PORT:$GATEWAY_PORT on an untrusted network.
  -p "${GATEWAY_PORT}:${GATEWAY_PORT}"
  -i
)
if [[ "$MODE" == "chat" ]]; then
  # scripts/start_open_webui.sh honours this over config/application.yaml.
  RUN_ARGS+=(-e "OPEN_WEBUI_DATA_PATH=$OPEN_WEBUI_DATA")
  # The address the printed Open WebUI URL should name. Inside the container
  # the launcher would otherwise find only the container's own name.
  HOST_ADDRESS="$( { ip route get 1.1.1.1 2>/dev/null || true; } |
    sed -n 's/.*src \([^ ]*\).*/\1/p')"
  [[ -n "$HOST_ADDRESS" ]] && RUN_ARGS+=(-e "GENIEX_HOST_ADDRESS=$HOST_ADDRESS")
fi
# The board name qcperf's libcdsprpc needs; see the qcperf telemetry group above.
if [[ -n "$QCPERF_MACHINE_NAME" ]]; then
  RUN_ARGS+=(-e "GENIEX_QCPERF_MACHINE_NAME=$QCPERF_MACHINE_NAME")
fi
# Only allocate a TTY when there is one, so the script still works from a pipe,
# a service unit or cron.
[[ -t 0 ]] && RUN_ARGS+=(-t)

COMMAND=(docker run "${RUN_ARGS[@]}" "${DOCKER_ARGS[@]}" "$IMAGE" --c "$CONFIG_TARGET")

if ((DRY_RUN == 1)); then
  printf '%q ' "${COMMAND[@]}"
  printf '\n'
  exit 0
fi

# Created here rather than by docker, which --mount would refuse to do anyway.
mkdir -p "$LOG_DIR" "$STATE_DIR"
[[ "$MODE" == "chat" ]] && mkdir -p "$OPEN_WEBUI_DATA"
# A previous run's lifecycle state must not outlive its container. If it says
# "error", app/common/wait.py reads it before the new lifecycle manager has
# rewritten it and aborts the fresh start, which then kills GenieX mid-load.
# Safe here: the container-name check above guarantees nothing is running.
rm -f "$STATE_DIR/geniex-state.json"

echo "Starting $CONTAINER from $IMAGE: mode=$MODE runtime=$RUNTIME backend=$BACKEND"
if [[ "$MODE" == "vlm" ]]; then
  echo "Press q in the desktop window, or Ctrl+C here, to stop."
fi

# Chat mode only. The demo stops Open WebUI itself on an orderly exit; this
# catches a container that died without one - killed, or out of memory - so a
# sibling Open WebUI container is never left running with nothing behind it.
remove_open_webui() {
  local leftovers
  leftovers="$(docker ps -aq --filter "label=com.docker.compose.project=$COMPOSE_PROJECT")"
  if [[ -n "$leftovers" ]]; then
    echo "Removing the Open WebUI container left behind"
    # shellcheck disable=SC2086 # one container id per word
    docker rm -f $leftovers >/dev/null
  fi
}
# Ctrl+C reaches docker run, which forwards it to the demo; this shell only waits
# for that to finish and then cleans up.
trap ':' INT
status=0
"${COMMAND[@]}" || status=$?
[[ "$MODE" == "chat" ]] && remove_open_webui
# 130 is the demo's orderly exit after SIGINT - Ctrl+C here, or `docker stop`,
# whose stop signal is SIGINT. That is how the demo is meant to be stopped, so it
# is reported as success rather than as a failure iqs-launcher would log.
((status == 130)) && status=0
exit "$status"
