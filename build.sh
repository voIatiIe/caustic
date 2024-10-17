#!/bin/bash

set -e

echo "Building everything..."

pushd engine
source build.sh
popd

pushd testbed
source build.sh
popd

echo "Everything built!"
