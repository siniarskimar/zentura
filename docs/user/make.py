#!/bin/env python
from pathlib import Path
import subprocess
import sys

if sys.version_info[0] < 3 or (sys.version_info[1] < 4):
    print("Python 3.4+ required!", file=sys.stderr)
    exit(1)

__dirname__ = Path(__file__).parent
sys.path.append(str(__dirname__.parent))

from common import find_program

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
