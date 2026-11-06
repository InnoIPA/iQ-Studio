#!/bin/bash

# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# This script handles the installation of iqs-launcher.

# Exit on error and print commands.
set -ex

# --- Variables ---
# Project root directory.
ROOT="$(dirname "$(readlink -f "$0")")"
# System-wide installation path for the command.
INSTALL_PATH="/usr/local/bin"
# Path for the Python virtual environment.
PYTHON_VENV="$ROOT/iqs-venv"

# --- Check BSP version ---
# The applications in this repository require BSP v2.5.0 or later.
# Override BSP_VERSION_FILE only for testing.
BSP_VERSION_FILE="${BSP_VERSION_FILE:-/etc/innodisk/BSP-version}"
REQUIRED_BSP="2.5"

if [ ! -f "$BSP_VERSION_FILE" ]; then
    echo "Error: $BSP_VERSION_FILE not found." >&2
    echo "iQ-Studio requires an Innodisk BSP image. See https://github.com/InnoIPA/meta-iQ__manifest" >&2
    exit 1
fi

BSP_VERSION=$(grep -oE '[0-9]+\.[0-9]+' "$BSP_VERSION_FILE" | head -1 || true)
if [ -z "$BSP_VERSION" ]; then
    echo "Error: could not read a version number from $BSP_VERSION_FILE." >&2
    exit 1
fi

# Compare major.minor numerically so that later BSP versions (e.g. 2.10, 3.0) pass.
BSP_MAJOR="${BSP_VERSION%%.*}"
BSP_MINOR="${BSP_VERSION#*.}"
REQ_MAJOR="${REQUIRED_BSP%%.*}"
REQ_MINOR="${REQUIRED_BSP#*.}"
if [ "$BSP_MAJOR" -lt "$REQ_MAJOR" ] || { [ "$BSP_MAJOR" -eq "$REQ_MAJOR" ] && [ "$BSP_MINOR" -lt "$REQ_MINOR" ]; }; then
    echo "Error: BSP $BSP_VERSION is not supported. iQ-Studio requires BSP v$REQUIRED_BSP.0 or later." >&2
    echo "For an earlier BSP, run 'git checkout v0.0.10' in the iQ-Studio directory and run ./install.sh again." >&2
    exit 1
fi

# --- Setup ---
# Create and activate Python virtual environment.
mkdir -p "$PYTHON_VENV" || echo "venv directory already exists."
python3 -m venv "$PYTHON_VENV"
source "$PYTHON_VENV/bin/activate"

# --- Install ---
# Link the launcher script to the install path to make it a global command.
ln -sf "$ROOT/iqs-launcher.sh" "$INSTALL_PATH/iqs-launcher"

# Make scripts executable.
chmod +x "$ROOT/iqs-launcher.sh"
chmod +x "$ROOT/launcher.py"
