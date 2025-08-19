#!/bin/sh

Package="wayland"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"
Clone="https://gitlab.freedesktop.org/wayland/wayland"

rm -rf "$Bin"
rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources"

meson build/ --prefix="$Bin"
ninja -C build/ install

cd -
