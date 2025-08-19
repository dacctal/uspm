#!/bin/sh

Package="uspm"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"
Clone="https://github.com/dacctal/uspm.git"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources" || exit

./build.sh
mkdir -p "$(dirname "$Bin")"
cp uspm "$Bin"

cd - || exit
