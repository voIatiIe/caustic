#!/bin/bash

set -e

mkdir -p ../bin

cFiles=$(find . -type f -name "*.c")

assembly="engine"

compilerFlags="-g -fPIC -dynamiclib -install_name @rpath/lib${assembly}.dylib"
includeFlags="-Isrc -I$VULKAN_SDK/include"
linkerFlags="-lvulkan -L$VULKAN_SDK/lib"
defines="-D_DEBUG -DCEXPORT"

echo "Building ${assembly}..."

clang $cFiles $compilerFlags -o ../bin/lib${assembly}.dylib $includeFlags $linkerFlags $defines

echo "${assembly} built!"
