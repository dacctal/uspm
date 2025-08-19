#!/bin/sh

Package="json-c"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"
Clone="https://github.com/json-c/json-c"

rm -rf $Sources

git clone "$Clone" "$Sources"
cd "$Sources" || exit

mkdir build
cd build
cmake .. # See CMake section below for custom arguments
cmake --build . --target json-c

cd -
