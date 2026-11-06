# Copyright (c) 2025 Innodisk Corp.
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import os 
import subprocess
import shlex
import logging
import json
import stat

class RUN:
    def __init__(self, args, root_path):
        self.args = args
        self.root_path = root_path
        applink_path = os.path.join(root_path, 'tutorials', 'metadata.json')
        try:
            with open(applink_path, 'r') as f:
                self.app_links = json.load(f)
        except (FileNotFoundError, json.JSONDecodeError) as e:
            logging.error(f"Could not load or parse metadata.json: {e}")
            self.app_links = {}

    def _get_script_path(self, component_name):
        script_rel_path = self.app_links.get(component_name)
        if not script_rel_path:
            raise FileNotFoundError(f"Component '{component_name}' not found in metadata.json")
        
        script_path = os.path.normpath(os.path.join(self.root_path, script_rel_path))

        if not os.path.isfile(script_path):
            raise FileNotFoundError(f"Execution script not found at path: {script_path}")
        
        return script_path

    def execute_script(self, component_name, *script_args):
        """Run the application script. Return True on success, False on failure."""
        if not component_name:
            logging.error("Component name not provided.")
            return False
        try:
            script_path = self._get_script_path(component_name)
            
            # Ensure the script is executable
            st = os.stat(script_path)
            if not (st.st_mode & stat.S_IEXEC):
                logging.info(f"Script at {script_path} is not executable. Adding execute permission.")
                os.chmod(script_path, st.st_mode | stat.S_IEXEC)

            command = [script_path] + list(script_args)
            if self.args.other:
                command.extend(shlex.split(self.args.other))

            logging.info(f"Execute command: {' '.join(command)}")
            subprocess.run(command, check=True)
            return True
        except (FileNotFoundError, subprocess.CalledProcessError) as e:
            logging.error(f"An error occurred while executing the script for component '{component_name}': {e}")
            return False
