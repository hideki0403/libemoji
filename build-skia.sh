#!/bin/bash

gn_path=$(dirname ${0})/externals/depot_tools/gn.py
ninja_path=$(dirname ${0})/externals/depot_tools/ninja.py

useTempDir=false

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  args='is_debug=false target_cpu="x64" is_official_build=true symbol_level=0 extra_cflags=["-MT"]'
else
  args="is_debug=false target_cpu=\"\"x64\"\" is_official_build=true skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_icu=false skia_use_system_harfbuzz=false skia_use_system_expat=false skia_use_system_zlib=false symbol_level=0 cc=\"\"clang\"\" cxx=\"\"clang++\"\" clang_win=\"\"%LLVM_PATH%\"\" win_vc=\"\"C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Enterprise\\VC\"\" extra_cflags=[\"\"-MT\"\"]"
  useTempDir=true
fi

echo build args: $args

if [[ "$useTempDir" == "true" ]]; then
  echo "export MSYS=winsymlinks:nativestrict" > ~/.bashrc
  source ~/.bashrc

  echo "Create symbolic link"
  mkdir -p "C:/buildtmp"
  ln -s "C:/buildtmp" ./out
  echo "successfully create symbolic link!" > ./out/test.txt
  cat "C:/buildtmp/test.txt"
fi

python3 tools/git-sync-deps
python3 ${gn_path} gen out/Static --args=$arg
echo "Start skia build"
python3 ${ninja_path} -C out/Static
echo "Finished skia build"
