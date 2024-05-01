#!/usr/bin/env python3

import subprocess
import sys
import uuid

class SimulatorDeviceError(Exception):
    pass

class SimulatorDeviceConfiguration:
    def __init__(self, device_type: str, platform: str, runtime_version: str):
        self.device_type = device_type
        self.platform = platform
        self.runtime_version = runtime_version

def create_simulator_device(device_name: str, config: SimulatorDeviceConfiguration, runtime_id: str) -> uuid.UUID:
    create_device_command = f"xcrun simctl create '{device_name}' '{config.device_type}' '{runtime_id}'"
    new_device_uuid_string = _shell(create_device_command)
    try:
        return str(uuid.UUID(new_device_uuid_string)).upper()
    except ValueError:
        raise SimulatorDeviceError("Failed to create a new device.")

def find_existing_simulator_device(device_name: str) -> uuid.UUID:
    existing_device_command = f"xcrun simctl list devices | grep '{device_name}' | grep -o -E '\\([0-9A-F-]+\\)' | tr -d '()'"
    existing_device_uuid_string = _shell(existing_device_command).split('\n')[0]
    try:
        return uuid.UUID(existing_device_uuid_string)
    except ValueError:
        return None

def get_or_create_simulator_device(device_name: str, config: SimulatorDeviceConfiguration) -> uuid.UUID:
    existing_device_uuid = find_existing_simulator_device(device_name)
    if existing_device_uuid:
        return existing_device_uuid

    runtime_id = _get_runtime_id(config.platform, config.runtime_version)
    return create_simulator_device(device_name, config, runtime_id)

def _shell(command: str) -> str:
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, executable='/bin/zsh')
    stdout, stderr = process.communicate()
    if process.returncode != 0:
        raise SimulatorDeviceError(stderr.decode('utf-8'))
    return stdout.decode('utf-8').strip()

def _get_runtime_id(platform: str, runtime_version: str) -> str:
    runtime_pattern = {
        'iOS': 'iOS',
        'watchOS': 'watchOS',
        'tvOS': 'tvOS',
        'visionOS': 'visionOS'
    }.get(platform, 'iOS')  # Default to iOS if platform is unrecognized
    runtime_id_command = f"xcrun simctl list runtimes | grep '{runtime_pattern}' | grep '{runtime_version}' | grep -o -E 'com.apple.CoreSimulator.SimRuntime.{platform}-[0-9-]+' | head -1"
    return _shell(runtime_id_command)

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: ./simulator.py <deviceName> <deviceType> <platform> <runtimeVersion>", file=sys.stderr)
        sys.exit(1)

    device_name = sys.argv[1]
    fallbackConfiguration= SimulatorDeviceConfiguration(sys.argv[2], sys.argv[3], sys.argv[4])

    try:
        device_uuid = get_or_create_simulator_device(device_name, fallbackConfiguration)
        print(str(device_uuid).upper())
    except SimulatorDeviceError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
        