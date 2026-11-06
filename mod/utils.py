# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import logging

def split_autotag(value: str) -> tuple[str, str]:
    name, sep, tag = value.partition(':')
    if not tag:
        tag = 'latest'
    return name, tag