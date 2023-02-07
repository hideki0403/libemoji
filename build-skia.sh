#!/bin/bash

gn_path=$(dirname ${0})/externals/depot_tools/gn.py
ninja_path=$(dirname ${0})/externals/depot_tools/ninja.py

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  args='is_debug=false target_cpu="x64" is_official_build=true skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_icu=false skia_use_system_harfbuzz=false skia_use_system_expat=false skia_use_system_zlib=false extra_cflags=["-MTd"]'
else
  args="is_debug=false target_cpu=\"\"x64\"\" is_official_build=true skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_icu=false skia_use_system_harfbuzz=false skia_use_system_expat=false skia_use_system_zlib=false cc=\"\"clang\"\" cxx=\"\"clang++\"\" clang_win=\"\"%LLVM_PATH%\"\" win_vc=\"\"C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Enterprise\\VC\"\" extra_cflags=[\"\"-MTd\"\"]"
fi

echo build args: $args

python3 tools/git-sync-deps
python3 ${gn_path} gen out/Static --args=$arg
echo "Start skia build"
python3 ${ninja_path} -C out/Static
echo "Finished skia build"
