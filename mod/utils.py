# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import logging

def get_system_bsp_version():
    """
    Gets the system's BSP version from /etc/innodisk/BSP-version.
    
    Raises:
        FileNotFoundError: If the BSP version file does not exist.
        ValueError: If the BSP version file is empty.
    
    Returns:
        str: The BSP version string.
    """
    # bsp_version_file = "/etc/innodisk/BSP-version"
    # try:
    #     with open(bsp_version_file, 'r', encoding='utf-8') as f:
    #         version = f.read().strip()
    #         if not version:
    #             msg = f"BSP version file is empty: {bsp_version_file}"
    #             logging.error(msg)
    #             raise ValueError(msg)
    #         logging.info(f"Got BSP version: '{version}' from {bsp_version_file}")
    #         return version
    # except FileNotFoundError:
    #     msg = f"Critical: BSP version file not found at: {bsp_version_file}"
    #     logging.error(msg)
    #     raise
    # except Exception as e:
    #     msg = f"An unhandled error occurred while reading BSP version: {e}"
    #     logging.error(msg)
    #     raise
    return ""


def split_autotag(value: str) -> tuple[str, str]:
    name, sep, tag = value.partition(':')
    if not tag:
        tag = 'latest'
    return name, tag