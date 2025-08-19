#!/bin/sh

Package="wayland"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"

rm -rf "$Bin"
rm -rf "$Sources"

git clone https://gitlab.freedesktop.org/wayland/wayland.git "$Sources"
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git "$Sources"/wayland-protocols
cd "$Sources"

meson setup builddir --prefix="$Sources"
ninja -C builddir
ninja -C builddir install

cd wayland-protocols
meson setup builddir --prefix="$Sources"
ninja -C builddir
ninja -C builddir install

cd -
