#!/bin/bash

gn_path=externals/depot_tools/gn
ninja_path=externals/depot_tools/ninja

echo build args: $1

python3 tools/git-sync-deps
$gn_path gen out/Static --args=$1
echo "Start skia build"
${ninja_path} -C out/Static
echo "Finished skia build"
