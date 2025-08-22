#!/bin/sh

Package="llvm"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"

Builds="$HOME/.local/share/uspm/sources/llvm/build/bin"

for binfile in "$Builds"/*; do
  if [ -f "$binfile" ]; then
    rm "$Bin"/"$(basename "$binfile")"
  fi
done

rm -rf "$Sources"
