#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import sys

def add_platform_suffix_to_classname(xml_file, platform_suffix):
    tree = ET.parse(xml_file)
    root = tree.getroot()

    for testcase in root.iter('testcase'):
        name = testcase.get('name')
        if name:
            testcase.set('name', f"{name} [{platform_suffix}]")

    tree.write(xml_file)

if __name__ == "__main__":
    xml_file_path = sys.argv[1]
    platform_suffix = sys.argv[2]
    add_platform_suffix_to_classname(xml_file_path, platform_suffix)
