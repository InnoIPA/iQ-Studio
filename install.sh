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

# --- Detect OS ---
if grep -qi "ubuntu" /etc/os-release; then
    sudo apt update && sudo apt install -y \
        qcom-fastrpc-dev qcom-fastrpc1 \
        python3.12-venv \
        docker.io 
    sudo usermod -aG docker $USER
fi

# --- Setup ---
# Create and activate Python virtual environment.
mkdir -p "$PYTHON_VENV" || echo "venv directory already exists."
python3 -m venv "$PYTHON_VENV"
source "$PYTHON_VENV/bin/activate"

# --- Install ---
# Link the launcher script to the install path to make it a global command.
if grep -qi "ubuntu" /etc/os-release; then
    sudo ln -sf "$ROOT/iqs-launcher.sh" "$INSTALL_PATH/iqs-launcher"
else
    ln -sf "$ROOT/iqs-launcher.sh" "$INSTALL_PATH/iqs-launcher"
fi

# Make scripts executable.
chmod +x "$ROOT/iqs-launcher.sh"
chmod +x "$ROOT/launcher.py"
