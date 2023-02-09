#!/bin/bash

# clang-tidy.sh [directory with compile_commands.json]

BUILD_DIRECTORY=
SCRIPT_DIR=$(dirname $0)
REPO_ROOT="$SCRIPT_DIR/.."

if [[ -e "$REPO_ROOT/build" && -e "$REPO_ROOT/build/compile_commands.json" && -e "$REPO_ROOT/meson.build" ]]; then
  BUILD_DIRECTORY="-p $REPO_ROOT/build"
fi;

if [[ $# -ge 1 ]]; then
  BUILD_DIRECTORY="-p $1"
fi;

clang-tidy $BUILD_DIRECTORY $( find ./src -type f \( -iname \*.cpp -o -iname \*.hpp \) ) $*
