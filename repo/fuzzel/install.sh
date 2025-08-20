#!/bin/sh

Package="fuzzel"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://codeberg.org/dnkl/fuzzel.git"

rm -rf $Sources

git clone "$Clone" "$Sources"
cd "$Sources"

mkdir -p bld/release && cd bld/release
meson --buildtype=release --prefix="$Sources" \
  ../..
ninja
ninja install

cp fuzzel "$Bin"

cd -
cd -
