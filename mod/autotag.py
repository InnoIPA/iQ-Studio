# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import os
import subprocess
import json
import logging

class AUTOTAG:
    def __init__(self, args, root_path, image_tag=None, app_name=None):
        #
        self.args = args
        raw = app_name or self.args.autotag  # e.g. "iqs-ogenie" or "iqs-ogenie:0.0.3"

        if ':' in raw:
            self.image_name, self.image_tag = raw.split(':', 1)
        else:
            self.image_name = raw
            self.image_tag = image_tag or 'latest'

        self.docker_image_dir = os.path.normpath(os.path.join(root_path, 'binaries', 'docker-images'))
    def _check_local_image(self):
        logging.info("Step 1: Check if your local Docker image exists...")
        try:
            target = f"innodiskorg/{self.image_name}:{self.image_tag}"
            result = subprocess.run(
                ['docker', 'images', '--format', '{{.Repository}}:{{.Tag}}'],
                check=True, capture_output=True, text=True
            )
            images = result.stdout.strip().splitlines()
            if target in images:
                logging.info(f"Success: Found local image {target}")
                return target
            logging.info(f"No local image named {target}")
            return None
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            logging.error(f"Error checking local image: {e}")
            return None

    def _check_tar_archive(self):
        logging.info("Step 2: Check the .tar archive...")
        tar_path = os.path.join(self.docker_image_dir, f'{self.image_name}.tar')
        if not os.path.isfile(tar_path):
            logging.info(f"Could not find .tar archive at {tar_path}.")
            return None

        logging.info(f"Found .tar archive: {tar_path}, loading with docker...")
        try:
            subprocess.run(['docker', 'load', '-i', tar_path], check=True)
            
            loaded_image = f"innodiskorg/{self.image_name}:{self.image_tag}"
            logging.info(f"Loaded image, assuming name: {loaded_image}")
            return loaded_image
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            logging.error(f"Error loading .tar archive: {e}")
            return None

    def _pull_from_hub(self):
        logging.info("Step 3: Try downloading from Docker Hub...")
        image_to_pull = f"innodiskorg/{self.image_name}:{self.image_tag}"
        logging.info(f"PULL: {image_to_pull}")
        ...
        return image_to_pull

    def ensure_compatible_image_exists(self):
        if (found_image := self._check_local_image()):
            return found_image

        if (found_image := self._check_tar_archive()):
            return found_image

        if (found_image := self._pull_from_hub()):
            return found_image

        logging.info("--- All methods failed ---")
        return None