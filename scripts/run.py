import subprocess
import sys
import shutil
import os
import platform
from pathlib import Path


def main():
    argv = sys.argv
    if len(argv) < 2:
        print('usage: ' + argv[0] + ' <build_dir>')
        exit(1)
    build_dir = Path(argv[1])
    if not build_dir.exists():
        print(str(build_dir) + ' doesn\'t exist')
        exit(1)

    ninja = shutil.which('ninja')
    if ninja is None:
        print('\'ninja\' has not been found in $PATH')
        exit(1)

    build_ninja = Path(build_dir, 'build.ninja')
    compile_commands = Path(build_dir, 'compile_commands.json')
    meson_info = Path(build_dir, 'mesin-info')
    zen_exe = Path(build_dir, 'src', 'zen')

    if platform.system() == 'Windows':
        zen_exe = Path(build_dir, 'src', 'zen.exe')

    if (not build_ninja.exists()
            and not compile_commands.exists()
            and not meson_info.exists()):
        print(str(build_dir) + ' is not a valid Meson build directory')
        exit(1)

    os.chdir(build_dir)

    subprocess.run([ninja], shell=False, check=True)
    subprocess.run([zen_exe] + argv[1:], shell=False, check=True)


if __name__ == "__main__":
    main()
