#!/bin/bash

# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Exit immediately if a command fails.
set -e

# The first argument ($1) is the Docker image name provided by iqs-launcher.
IMAGE_TO_RUN="$1"

# Use 'shift' to remove the image name from the argument list.
# Now, $@ contains only the arguments passed via the --other flag.
shift

# Execute the container using the provided image name and pass any additional arguments.
echo "Executing docker run on image: $IMAGE_TO_RUN with args: $@"

VOLUME_RUN=""
if grep -qi "ubuntu" /etc/os-release; then
    VOLUME_RUN="-v /run:/run"
    OS_TYPE="ubuntu"
fi

# Config the container will load: the -c argument, else the image default.
CONFIG_PATH=/app/configs/adb_config/videos/config_ppe.json
ARGS=("$@")
for ((i = 0; i < ${#ARGS[@]} - 1; i++)); do
    if [ "${ARGS[i]}" = "-c" ]; then
        CONFIG_PATH="${ARGS[i + 1]}"
    fi
done

# Reset the camera services before the container opens any GMSL channel, then
# wait for cam-server to come back up. This has to run on the host: the
# container has its own PID namespace, so a pkill inside it cannot see
# cam-server. 8-stream GMSL needs the longer wait; override with
# CAM_RESET_WAIT for lighter configs. Configs without a gmsl stream (e.g.
# video-only) skip the reset and the wait.
CAM_RESET_WAIT=${CAM_RESET_WAIT:-15}
if docker run --rm --entrypoint grep -v "$PWD":/workspace "$IMAGE_TO_RUN" \
    -qE '"source"[[:space:]]*:[[:space:]]*"gmsl"' "$CONFIG_PATH"; then
    pkill cam-server || true
    pkill gst || true
    sleep "$CAM_RESET_WAIT"
fi

# QLI 2.0 only: weston socket, glvnd EGL vendor, GBM table and the fastrpc DSP
# skel search path (without it the QNN HTP delegate fails and the app crashes).
# Mount only what exists on the host: docker would otherwise create an empty
# directory at every missing bind-mount source.
EXTRA_MOUNTS=()
for path in /run/user/1000 /usr/share/glvnd /etc/gbm /usr/share/qcom; do
    [ -d "$path" ] && EXTRA_MOUNTS+=(-v "$path:$path")
done

# Allocate a TTY only when we actually have one, so the script also works
# when launched in the background (nohup, systemd, ssh without -t).
TTY_FLAG=""
if [ -t 0 ]; then
    TTY_FLAG="-t"
fi

docker run --rm -i $TTY_FLAG \
    --name iqs-qvadk \
    --net host \
    --privileged \
    --shm-size=3g \
    -e OS_TYPE="$OS_TYPE" \
    -v /dev/:/dev \
    -v /run/cam_server:/run/cam_server \
    -v /usr/lib:/host_lib \
    -v /usr/libexec:/host_libexec \
    "${EXTRA_MOUNTS[@]}" \
    $VOLUME_RUN \
    -v "$PWD":/workspace \
    "$IMAGE_TO_RUN" \
    "$@"
