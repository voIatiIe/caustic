#!/bin/bash

set -e

mkdir -p ../bin

cFiles=$(find . -type f \( -name "*.c" -o -name "*.m" \))

assembly="engine"

compilerFlags="-g -fPIC -fvisibility=hidden -dynamiclib -install_name @rpath/lib${assembly}.dylib -framework Cocoa -framework QuartzCore"
includeFlags="-Isrc -I$VULKAN_SDK/include"
linkerFlags="-lvulkan -L$VULKAN_SDK/lib"
defines="-D_DEBUG -DCEXPORT"

echo "Building ${assembly}..."

clang $defines $includeFlags $linkerFlags $cFiles $compilerFlags -o ../bin/lib${assembly}.dylib

echo "${assembly} built!"
