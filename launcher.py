#!/usr/bin/env python3

# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import argparse
import logging
import os
from mod.autotag import AUTOTAG
from mod.ipk import IPK
from mod.run import RUN
from mod.utils import get_system_bsp_version, split_autotag

def main():
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    
    project_root = os.path.dirname(os.path.realpath(__file__))

    # Get system BSP version once
    try:
        system_bsp = get_system_bsp_version()
    except (FileNotFoundError, ValueError) as e:
        logging.critical(f"Could not determine system BSP version: {e}")
        logging.critical("Cannot proceed without BSP version. Exiting.")
        return

    ap = argparse.ArgumentParser()
    ap.add_argument("--autotag", type=str, default=None, help="choose iq-container docker image")
    ap.add_argument("--ipk",  type=str, default=None, help="install ipk file")
    ap.add_argument("--other",  type=str, default=None, help="entry for other commands")
    args = ap.parse_args()
    
    autotag = AUTOTAG(args, project_root)
    run = RUN(args, project_root)
    ipk = IPK(args, project_root, bsp_version=system_bsp)

    if args.autotag is not None:
        app_name, image_tag = split_autotag(args.autotag)
        logging.info(f"--- Autotag flow for {app_name} (tag={image_tag}) ---")

        autotag = AUTOTAG(args, project_root, image_tag=image_tag, app_name=app_name)

        if (compatible_image := autotag.ensure_compatible_image_exists()):
            run.execute_script(app_name, compatible_image)
        
        if args.ipk is not None:
            logging.info(f"--- IPK installation process for {args.ipk} ---")
            if ipk.is_installed():
                run.execute_script(args.ipk)
            else:
                compatible_ipk_path = ipk.find_compatible_path()
                if compatible_ipk_path and ipk.install(compatible_ipk_path):
                    run.execute_script(args.ipk)

if __name__ == "__main__":
    main()