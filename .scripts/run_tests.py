#!/usr/bin/env python3

import subprocess
import sys

from simulator import get_or_create_simulator_device, SimulatorDeviceConfiguration, SimulatorDeviceError
from xcodebuild import test_in_simulator, test_on_macos, XcodeBuildError
from utilities import get_mac_architecture

device_configurations = {
	"iOS": {
		"device_name": "iPhone 15 Pro",
		"device_type": "iPhone 15 Pro",
		"platform": "iOS",
		"runtime_version": "17.2"
	},
	"watchOS": {
		"device_name": "Apple Watch Ultra 2 (49mm)",
		"device_type": "Apple Watch Ultra 2 (49mm)",
		"platform": "watchOS",
		"runtime_version": "10.2"
	},
	"tvOS": {
		"device_name": "Apple TV 4K (3rd generation)",
		"device_type": "Apple TV 4K (3rd generation)",
		"platform": "tvOS",
		"runtime_version": "17.2"
	},
	"visionOS": {
		"device_name": "Apple Vision Pro",
		"device_type": "Apple Vision Pro",
		"platform": "visionOS",
		"runtime_version": "1.0"
	},
	"macOS": {
		"catalyst": True
	}
}

def run_tests_ios(scheme: str, project_path: str):
	config = device_configurations["iOS"]
	simulator_config = SimulatorDeviceConfiguration(config['device_type'], config['platform'], config['runtime_version'])
	try:
		simulator_device_id = get_or_create_simulator_device(config['device_name'], simulator_config)
		test_in_simulator(scheme, simulator_device_id, project_path)
	except (SimulatorDeviceError, XcodeBuildError) as e:
		exit(1)

def run_tests_watchos(scheme: str, project_path: str):
	config = device_configurations["watchOS"]
	simulator_config = SimulatorDeviceConfiguration(config['device_type'], config['platform'], config['runtime_version'])
	try:
		simulator_device_id = get_or_create_simulator_device(config['device_name'], simulator_config)
		test_in_simulator(scheme, simulator_device_id, project_path)
	except (SimulatorDeviceError, XcodeBuildError) as e:
		exit(1)

def run_tests_tvos(scheme: str, project_path: str):
	config = device_configurations["tvOS"]
	simulator_config = SimulatorDeviceConfiguration(config['device_type'], config['platform'], config['runtime_version'])
	try:
		simulator_device_id = get_or_create_simulator_device(config['device_name'], simulator_config)
		test_in_simulator(scheme, simulator_device_id, project_path)
	except (SimulatorDeviceError, XcodeBuildError) as e:
		exit(1)

def run_tests_visionos(scheme: str, project_path: str):
	test_runner_architecture = get_mac_architecture()
	if test_runner_architecture != "arm64":
		return
	
	config = device_configurations["visionOS"]
	simulator_config = SimulatorDeviceConfiguration(config['device_type'], config['platform'], config['runtime_version'])
	try:
		simulator_device_id = get_or_create_simulator_device(config['device_name'], simulator_config)
		test_in_simulator(scheme, simulator_device_id, project_path)
	except (SimulatorDeviceError, XcodeBuildError) as e:
		exit(1)

def run_tests_macos(scheme: str, project_path: str):
	config = device_configurations["macOS"]
	try:
		test_on_macos(scheme, project_path, config["catalyst"])
	except XcodeBuildError as e:
		exit(1)

def main(scheme: str, platform: str, project_path: str):
	if platform == "iOS":
		run_tests_ios(scheme, project_path)
	elif platform == "watchOS":
		run_tests_watchos(scheme, project_path)
	elif platform == "tvOS":
		run_tests_tvos(scheme, project_path)
	elif platform == "visionOS":
		run_tests_visionos(scheme, project_path)
	elif platform == "macOS":
		run_tests_macos(scheme, project_path)
	else:
		print(f"Unsupported platform: {platform}")
		exit(1)

if __name__ == "__main__":
	if len(sys.argv) != 4:
		print("Usage: ./test_runner.py <scheme> <platform> <project_absolute_path>", file=sys.stderr)
		sys.exit(1)
		
	_, scheme, platform, project_path = sys.argv
	main(scheme, platform, project_path)
