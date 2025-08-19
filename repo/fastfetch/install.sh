#!/bin/sh

Package="fastfetch"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/fastfetch-cli/fastfetch.git"

rm -rf $Sources

git clone "$Clone" "$Sources"
cd "$Sources"

mkdir -p build
cd build

cmake ..
cmake --build . --target fastfetch
sudo cp fastfetch "$Bin"

cd -
cd -
