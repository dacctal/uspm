#!/bin/sh

Package="wayland"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"

rm -rf "$Bin"
rm -rf "$Sources"
