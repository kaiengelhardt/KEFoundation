#!/usr/bin/env python3

import subprocess

def get_mac_architecture() -> str:
	return subprocess.check_output(['uname', '-m']).strip().decode('utf-8')
