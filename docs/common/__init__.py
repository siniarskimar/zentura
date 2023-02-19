from pathlib import Path
import os
import platform


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
