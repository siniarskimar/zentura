#!/bin/env python3
import subprocess
import shutil
import argparse
from pathlib import Path
from typing import Optional, List
import os
import platform
import re
import fnmatch
import sys


SELF_DIR = Path(__file__).parent.resolve().absolute()
sys.path.append(str(SELF_DIR))

from pyutils import find_root_dir

CHECKS = [
    "readability-avoid-const-params-in-decls",
    "readability-braces-around-statements",
    "readability-const-return-type",
    "readability-container-contains",
    "readability-container-data-pointer",
    "readability-container-size-empty",
    "readability-delete-null-pointer",
    "readability-else-after-return",
    "readability-identifier-naming",
    "readability-inconsistent-declaration-parameter-name",
    "readability-isolate-declaration",
    "readability-make-member-function-const",
    "readability-misleading-indentation",
    "readability-misplaced-array-index",
    "readability-non-const-parameter",
    "readability-qualified-auto",
    "readability-redundant-access-specifiers",
    "readability-redundant-control-flow",
    "readability-redundant-declaration",
    "readability-redundant-function-ptr-dereference",
    "readability-redundant-member-init",
    "readability-redundant-preprocessor",
    "readability-redundant-smartptr-get",
    "readability-redundant-string-cstr",
    "readability-redundant-string-init",
    "readability-simplify-boolean-expr",
    "readability-simplify-subscript-expr",
    "readability-static-accessed-through-instance",
    "readability-static-definition-in-anonymous-namespace",
    "readability-string-compare",
    "readability-uniqueptr-delete-release"
]

def find_clang_tidy(cmdargs) -> Optional[Path]:
    result = cmdargs.clang_tidy_bin
    if result is not None:
        exists = Path(result).exists()
        is_executable = os.access(result, os.X_OK)

        if exists and is_executable:
            return Path(result)

        if exists and not is_executable:
            print(f"err: '{result}' exists but it's not executable")
            return None

    result = shutil.which("clang-tidy")
    if result is not None:
        return Path(result)

    return result


def collect_files(cmdargs, root) -> List[Path]:
    GLOBS = [
        "**/*.cpp",
        "**/*.hpp",
        "**/*.c",
        "**/*.h"    
    ]
    files = []
    ignored = []
    ignorefile = root / ".clang-tidy-ignore"
    if ignorefile.exists():
        with open(ignorefile) as ignorefd:
            for ignore in ignorefd.readlines():
                ignorepath = Path(root, ignore.strip())
                compiled = re.compile(fnmatch.translate(str(ignorepath)))
                ignored.append(compiled)

    ignored.append(
        re.compile(fnmatch.translate(str(root / "build") + '/*'))
    )
    ignored.append(
        re.compile(fnmatch.translate(str(root / "builddir") + '/*'))
    )

    for glob in GLOBS:
        for file in root.glob(glob):
            ignore = False

            for ignore_re in ignored:
                if ignore_re.match(str(file)):
                    ignore = True
                    break

            if ignore:
                continue

            files.append(file)
    return files

if __name__ == "__main__":
    argparser = argparse.ArgumentParser()
    argparser.add_argument("builddir", type=Path, help="Path to configured build directory")
    argparser.add_argument("--clang-tidy-bin", type=Path, help="Path to clang-tidy executable")

    cmdargs = argparser.parse_args()
    clang_tidy = find_clang_tidy(cmdargs)
    rootdir = find_root_dir(SELF_DIR)
    files = collect_files(cmdargs,rootdir)

    if clang_tidy is None:
        print("err: could not find clang-tidy", file=sys.stderr)
        exit(1)

    print(f"info: using {clang_tidy}", file=sys.stderr)

    checks_str = ','.join(CHECKS)
    
    runresult = subprocess.run(
        [
            clang_tidy,
            "-p", str(cmdargs.builddir),
            "--checks", "-*," + checks_str ,
            "--warnings-as-errors", checks_str
        ] + [str(x) for x in files],
        shell=False,
        check=False
    )

    if runresult.returncode != 0:
        print("err: some errors were generated", file=sys.stderr)
        exit(runresult.returncode)
