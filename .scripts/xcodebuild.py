#!/usr/bin/env python3

import contextlib
import subprocess
import os
import sys
import uuid
from utilities import get_mac_architecture

class XcodeBuildError(Exception):
    pass

def build_for_simulator(scheme: str, simulator_device_id: uuid.UUID, project_path: str):
    _perform_xcodebuild_command(f"xcodebuild -scheme {scheme} -destination 'id={str(simulator_device_id).upper()}' build", project_path)

def test_in_simulator(scheme: str, simulator_device_id: uuid.UUID, project_path: str):
    _perform_xcodebuild_command(f"xcodebuild -scheme {scheme} -destination 'id={str(simulator_device_id).upper()}' test", project_path)

def build_for_macos(scheme: str, project_path: str, catalyst: bool = False, architecture: str = None):
    if architecture is None:
        architecture = get_mac_architecture()
    destination = "platform=macOS,arch=" + architecture
    if catalyst:
        destination += ",variant=Mac Catalyst"
    _perform_xcodebuild_command(f"xcodebuild -scheme {scheme} -destination '{destination}' build", project_path)

def test_on_macos(scheme: str, project_path: str, catalyst: bool = False, architecture: str = None):
    if architecture is None:
        architecture = get_mac_architecture()
    destination = "platform=macOS,arch=" + architecture
    if catalyst:
        destination += ",variant=Mac Catalyst"
    _perform_xcodebuild_command(f"xcodebuild -scheme {scheme} -destination '{destination}' test", project_path)

@contextlib.contextmanager
def _temporary_chdir(path: str):
    original_dir = os.getcwd()
    try:
        os.chdir(path)
        yield
    finally:
        os.chdir(original_dir)
        
def _shell(command: str):
    process = subprocess.Popen(command, shell=True)
    process.wait()
    if process.returncode != 0:
        raise XcodeBuildError(f"Command failed with exit code {process.returncode}")
        
def _perform_xcodebuild_command(command: str, project_path: str):
    with _temporary_chdir(project_path):
        try:
            _shell(command)
        except XcodeBuildError:
            exit(1)
