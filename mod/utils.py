# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import subprocess

def split_autotag(value: str) -> tuple[str, str]:
    name, sep, tag = value.partition(':')
    if not tag:
        tag = 'latest'
    return name, tag

def join_option_value(argv: list[str], option: str) -> list[str]:
    """Turn '--other -x' into '--other=-x'.

    argparse reads a value that starts with '-' and has no space (for example
    "--dry-run") as another option and fails with "expected one argument".
    """
    out = []
    i = 0
    while i < len(argv):
        if argv[i] == option and i + 1 < len(argv) and argv[i + 1].startswith('-'):
            out.append(f"{option}={argv[i + 1]}")
            i += 2
        else:
            out.append(argv[i])
            i += 1
    return out

def docker_unavailable_reason() -> "str | None":
    """Return None when the Docker daemon answers, otherwise a short reason."""
    try:
        result = subprocess.run(
            ['docker', 'info', '--format', '{{.ServerVersion}}'],
            capture_output=True, text=True, timeout=30
        )
    except FileNotFoundError:
        return "the 'docker' command was not found"
    except subprocess.TimeoutExpired:
        return "Docker did not answer within 30 seconds"
    if result.returncode != 0:
        lines = (result.stderr or result.stdout).strip().splitlines()
        return lines[0] if lines else "Docker returned an error"
    return None
