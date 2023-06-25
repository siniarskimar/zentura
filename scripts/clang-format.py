#!/bin/env python3
import shutil
import os
import re
import sys
from pathlib import Path
import argparse
import subprocess
import fnmatch
import platform
import concurrent.futures
from typing import List, Tuple

ThreadPoolExecutor = concurrent.futures.ThreadPoolExecutor


SELF_DIR = Path(__file__).parent.absolute().resolve()


def get_clang_format_version(clangformat):
    output = subprocess.run([clangformat, "--version"], stdout=subprocess.PIPE, check=True, text=True).stdout.strip()

    i = output.find("version")
    if i == -1:
        return None

    i = i + len("version")
    version_str = output[i:len(output)].lstrip()

    match_groups = re.match(r'(\d+)\.(\d+)\.(\d+)', version_str).groups()
    version = {
        'major': int(match_groups[0]),
        'minor': int(match_groups[1]),
        'tweak': match_groups[2]     # version-revision
    }

    return version

def find_clang_format() -> Path:
    clangformat = shutil.which("clang-format")
    if clangformat is not None:
        return clangformat

    # Search for versioned clang-format
    env_path = os.getenv("PATH")
    filename_re = re.compile(r"clang-format-(\d+)")

    if platform.system() == "Windows":
        env_path = env_path.split(";")
    else:
        env_path = env_path.split(":")

    best_ver = None
    
    for path in env_path:
        for file in Path(path).glob("*"):
            m = filename_re.match(file.stem)
            if m is None:
                continue

            ver = int(m.groups()[0])
            if best_ver is not None and ver < best_ver:
                continue

            clangformat = file
            best_ver = ver

    return clangformat


def run_clang_format(clangformat: Path, file: Path, clangformat_10: bool, format: bool) -> Tuple[int, str, Path]:
    cmd = [clangformat, str(file)]
    orig_contents = None
    if format:
        cmd = cmd + ["-i"]
    else:
        if clangformat_10:
            cmd = cmd + ["--dry-run", "-Werror"]
        else:
            orig = open(file, "r")
            orig_contents = orig.read()
            orig.close()

    before = file.stat().st_mtime
    result = subprocess.run(cmd, text=True, stdin=subprocess.PIPE, stderr=subprocess.STDOUT, check=False)
    after = file.stat().st_mtime

    if not format and before != after:
        orig = open(file, "w")
        orig.write(orig_contents)
        orig.close()

    return (result.returncode, result.stdout, file)


def collect_files() -> List[Path]:
    GLOBS = [
        "**/*.cpp",
        "**/*.hpp",
        "**/*.c",
        "**/*.h"    
    ]
    files = []
    path = SELF_DIR

    while path != SELF_DIR.root:
        ignorefile = Path(path,".clang-format-ignore")
        if ignorefile.exists():
            ignored = []
            
            with open(ignorefile) as ignorefd:
                for ignore in ignorefd.readlines():
                    ignorepath = Path(path, ignore.strip())
                    ignored.append(re.compile(fnmatch.translate(str(ignorepath))))

            for glob in GLOBS:
                for file in path.glob(glob):
                    ignore = False

                    for ignore_re in ignored:
                        if ignore_re.match(str(file)):
                            ignore = True
                            break

                    if ignore:
                        continue

                    files.append(file)

        if path.joinpath(".git").exists():
            break
        path = path.parent

    return files

def main() -> int:
    argparser = argparse.ArgumentParser('run-clang-format.py',
        description="Runs clang-format with respect to .clang-format-ignore"    
    )
    argparser.add_argument("--format", action="store_true", help="Equivalent to -i argument, write format result back into the file")

    args = argparser.parse_args()
    clangformat = find_clang_format()
    if clangformat is None:
        print("err: 'clang-format' has not been found in PATH!", file=sys.stderr)
        exit(1)
    
    print(f"info: using {clangformat}", file=sys.stderr)
    clangformat_10 = get_clang_format_version(clangformat)['major'] >= 10
    format = args.format

    files = collect_files()

    returncode = 0

    with ThreadPoolExecutor() as executor:
        fs = []

        for file in files:
            fs.append(executor.submit(run_clang_format, clangformat, file, clangformat_10, format))     

        for future in concurrent.futures.as_completed(fs):
            try:
                res = future.result()
                if res[0] != 0:
                    returncode = 1
                
                if format and res[0] == 0:
                    print(f"'{res[2]}' formattted")
                
                if res[1] is not None and res[1] != '':
                    print(res[1])
                
            except Exception as ex:
                returncode = 2
                print(f"err: {ex}")
   
    return returncode


if __name__ == "__main__":
    exit(main())
