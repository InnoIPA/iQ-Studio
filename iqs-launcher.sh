#!/bin/bash

# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Exit immediately if a command exits with a non-zero status.
set -e

# Get the absolute path of the script's directory to locate venv and python scripts.
ROOT="$(dirname "$(readlink -f "$0")")"

# Activate the Python virtual environment.
# shellcheck source=/dev/null
source "$ROOT/iqs-venv/bin/activate"

# Add the project root to PYTHONPATH so that Python can find modules like autotag, run, etc.
export PYTHONPATH="$ROOT:$PYTHONPATH"

# Execute the main Python application, passing all command-line arguments ("$@") to it.
# 'exec' replaces the shell process with the python process.
exec python3 "$ROOT/launcher.py" "$@"
