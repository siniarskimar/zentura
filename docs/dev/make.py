#!/bin/env python
from pathlib import Path
import subprocess
import sys
import argparse as pyargparse
import os
import json

if sys.version_info[0] < 3 or (sys.version_info[1] < 4):
    print("Python 3.4+ required!", file=sys.stderr)
    exit(1)

if __name__ != "__main__":
    print(__file__ + " should be run as a script not a module!",
          file=sys.stderr)
    exit(1)

__dirname__ = Path(os.path.dirname(os.path.abspath(__file__))).resolve()
sys.path.insert(0, str(__dirname__.parent))

from common import find_program

argparser = pyargparse.ArgumentParser()
argparser.add_argument(
    '--output-directory',
    '-o',
    type=Path,
    help="Path to output directory",
    default=os.getcwd())
argparser.add_argument(
    '--doxygen-bin',
    type=Path,
    help="Path to doxygen executable"
)

args = argparser.parse_args()


def detect_doxygen_bin():
    if args.doxygen_bin is not None:
        if args.doxygen_bin.exists() and os.access(args.doxygen_bin, os.X_OK):
            return args.doxygen_bin
    return find_program('doxygen')


def extract_build_info():
    extracted_info = {
        "version": None
    }
    introspect_projectinfo = subprocess.run(
        [
            "meson",
            "introspect",
            "--projectinfo",
            "./meson.build"
        ],
        capture_output=True,
        check=True,
        cwd=str(Path(__dirname__.parent.parent))
    )
    project_info = json.loads(introspect_projectinfo.stdout)
    extracted_info["version"] = project_info["version"]
    return extracted_info


OUTPUT_DIR = Path(args.output_directory, 'doxygen')
DOXYGEN_BIN = detect_doxygen_bin()
DOXYFILE_PATH = Path(__dirname__, "Doxyfile")
BUILDINFO = extract_build_info()

doxyfile_content = ""

with open(DOXYFILE_PATH, 'r') as f:
    doxyfile_content = doxyfile_content + f.read()

doxyfile_content += "\nINPUT=" + str(Path(__dirname__.parent.parent, 'src').absolute())
doxyfile_content += "\nOUTPUT_DIRECTORY="+str(OUTPUT_DIR)
doxyfile_content += "\nPROJECT_NUMBER="+BUILDINFO["version"]

OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

subprocess.run([DOXYGEN_BIN, "-"], input=doxyfile_content.encode('utf-8'), check=True)
