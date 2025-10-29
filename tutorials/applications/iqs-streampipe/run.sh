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
docker run --rm -it \
    --net host \
    --privileged \
    --shm-size=3g \
    -v /dev/:/dev \
    -v /usr/lib:/host_lib \
    -v /usr/libexec:/host_libexec \
    -v /usr/lib/gbm/default_fmt_alignment.xml:/usr/lib/gbm/default_fmt_alignment.xml \
    -v /usr/share/mime:/usr/share/mime \
    -v $PWD:/workspace \
    "$IMAGE_TO_RUN" \
    "$@"

