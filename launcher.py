#!/usr/bin/env python3

# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import argparse
import logging
import os
import sys
from mod.autotag import AUTOTAG
from mod.run import RUN
from mod.utils import split_autotag, join_option_value, docker_unavailable_reason

def main():
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    
    project_root = os.path.dirname(os.path.realpath(__file__))

    ap = argparse.ArgumentParser(
        epilog="examples:\n"
               "  iqs-launcher --autotag iqs-qvadk\n"
               "  iqs-launcher --autotag iqs-vlm-demo --other \"--mode chat\"",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    ap.add_argument("--autotag", type=str, default=None, help="choose iq-container docker image")
    ap.add_argument("--other",  type=str, default=None, help="entry for other commands")
    args = ap.parse_args(join_option_value(sys.argv[1:], '--other'))

    if args.autotag is None:
        ap.exit(2, "Error: --autotag and an application name are required.\n"
                   "Example: iqs-launcher --autotag iqs-qvadk\n"
                   "Run 'iqs-launcher --help' for more examples.\n")

    run = RUN(args, project_root)
    app_name, image_tag = split_autotag(args.autotag)

    if app_name not in run.app_links:
        known = ", ".join(sorted(run.app_links)) or "(none, tutorials/metadata.json could not be read)"
        ap.exit(2, f"Error: unknown application '{app_name}'.\n"
                   f"Available applications: {known}\n"
                   "Example: iqs-launcher --autotag iqs-qvadk\n")

    reason = docker_unavailable_reason()
    if reason:
        ap.exit(1, f"Error: Docker is not available: {reason}\n"
                   "Check that Docker is installed and running (for example: systemctl status docker).\n")

    logging.info(f"--- Autotag flow for {app_name} (tag={image_tag}) ---")

    autotag = AUTOTAG(args, project_root, image_tag=image_tag, app_name=app_name)

    compatible_image = autotag.ensure_compatible_image_exists()
    if not compatible_image:
        ap.exit(1, f"Error: could not find a Docker image for {app_name}:{image_tag}.\n")
    if not run.execute_script(app_name, compatible_image):
        sys.exit(1)

if __name__ == "__main__":
    main()
