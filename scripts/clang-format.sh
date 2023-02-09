#!/bin/bash
SCRIPT_DIR=$(dirname $0)

find "$SCRIPT_DIR/../src" -type f \( -iname \*.cpp -o -iname \*.hpp \) -exec clang-format -i {} \;
