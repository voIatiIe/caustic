#!/bin/bash

set -e

mkdir -p ../bin

cFiles=$(find . -type f -name "*.c")

compilerFlags="-g -shared -fPIC -fdeclspec"
includeFlags="-Isrc -I$VULKAN_SDK/include"
linkerFlags="-lvulkan -L$VULKAN_SDK/lib"
defines="-D_DEBUG -DCEXPORT"

assembly="engine"

echo "Building ${assembly}..."

clang $cFiles $compilerFlags -o ../bin/lib${assembly}.so $includeFlags $linkerFlags $defines

echo "${assembly} built!"
