#!/bin/bash

set -e

mkdir -p ../bin

cFiles=$(find . -type f -name "*.c")

assembly="testbed"

compilerFlags="-g -fPIC"
includeFlags="-Isrc -I../engine/src/"
linkerFlags="-L../bin/ -lengine -Wl,-rpath,."
defines="-D_DEBUG"

echo "Building testbed..."

clang $defines $includeFlags $linkerFlags $cFiles $compilerFlags -o ../bin/testbed

echo "${assembly} built!"
