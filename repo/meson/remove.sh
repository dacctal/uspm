#!/bin/sh

Package="meson"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin"

sudo rm -rf "$Bin"/meson
sudo rm -rf "$Sources"
