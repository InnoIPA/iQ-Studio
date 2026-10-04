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
# QLI 2.0: the weston socket moved from /dev/socket/weston to /run/user/1000.
# The container still expects XDG_RUNTIME_DIR=/dev/socket/weston, so map it there.
if [ ! -S /dev/socket/weston/wayland-1 ] && [ -S /run/user/1000/wayland-1 ]; then
    VOLUME_RUN="-v /run/user/1000:/dev/socket/weston"
fi
# QLI 2.0: libcdsprpc (loaded from /host_lib) reads the CDSP fastrpc shell itself.
# It locates the shell through the machine table /usr/share/qcom/conf.d/*.yaml,
# which does not exist inside the container, so expose the host shell files on
# the default search path /usr/lib/rfsa/adsp.
MODEL=$(tr -d '\0' < /sys/firmware/devicetree/base/model 2>/dev/null || true)
DSP_REL=$(grep -h -A1 -E "^[[:space:]]+\"?${MODEL}\"?:" /usr/share/qcom/conf.d/*.yaml 2>/dev/null \
          | sed -n 's/.*DSP_LIBRARY_PATH: *//p' | tr -d '\"' | head -1)
if [ -n "$DSP_REL" ]; then
    for f in fastrpc_shell_3 fastrpc_shell_unsigned_3; do
        if [ -f "/usr/share/qcom/$DSP_REL/cdsp/$f" ]; then
            VOLUME_RUN="$VOLUME_RUN -v /usr/share/qcom/$DSP_REL/cdsp/$f:/usr/lib/rfsa/adsp/$f:ro"
        fi
    done
fi

# Allocate a TTY only when we actually have one, so the script also works
# when launched in the background (nohup, systemd, ssh without -t).
TTY_FLAG=""
if [ -t 0 ]; then
    TTY_FLAG="-t"
fi

docker run --rm -i $TTY_FLAG \
    --net host \
    --privileged \
    --shm-size=2g \
    -e OS_TYPE="$OS_TYPE" \
    -v /dev/:/dev \
    -v /usr/lib:/host_lib \
    $VOLUME_RUN \
    -v "$PWD":/workspace \
    "$IMAGE_TO_RUN" \
    "$@"
