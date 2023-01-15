#!/bin/env python
from pathlib import Path
import subprocess
import sys
import os
import platform

if sys.version_info[0] < 3 or (sys.version_info[1] < 4):
    print("Python 3.4+ required!", file=sys.stderr)
    exit(1)

def find_program(name: str) -> Path:
    ENV_PATH = os.getenv("PATH")
    isWindows = platform.system() == 'Windows'

    if isWindows:
        ENV_PATH = ENV_PATH.split(';')
    else:
        ENV_PATH = ENV_PATH.split(':')
    
    suffixes = [
        '' if not isWindows else '.exe',
        '.bat' if isWindows else None
    ]

    for path in ENV_PATH:
        for suffix in suffixes:
            if suffix is None:
                continue
            candidate = Path(path, name + suffix)
            if candidate.exists():
                return candidate
    return None

sphinxBuild = find_program('sphinx-build')

if sphinxBuild is None:
    print("Could not find 'sphinx-build' in $PATH!", file=sys.stderr)
    exit(1)

runargs = [sphinxBuild]
for arg in sys.argv[1:]:
    runargs.append(arg)

subprocess.run(
    runargs,
    shell=False
).check_returncode()
