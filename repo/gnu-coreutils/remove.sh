#!/bin/sh

Package="gnu-coreutils"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"

Builds="$HOME/.local/share/uspm/sources/gnu-coreutils/build/bin"

for binfile in "$Builds"/*; do
  if [ -f "$binfile" ]; then
    rm "$Bin"/"$(basename "$binfile")"
  fi
done

rm -rf "$Sources"
