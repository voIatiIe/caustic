#!/bin/bash

set -e

mkdir -p ../bin

cFiles=$(find . -type f -name "*.c")

compilerFlags="-g -fPIC"
includeFlags="-Isrc -I../engine/src/"
linkerFlags="-L../bin/ -lengine -Wl,-rpath,."
defines="-D_DEBUG -DCIMPORT"

assembly="testbed"

echo "Building testbed..."

clang $cFiles $compilerFlags -o ../bin/testbed $includeFlags $linkerFlags $defines

echo "${assembly} built!"
