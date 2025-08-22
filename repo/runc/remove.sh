#!/bin/sh

Package="runc"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"

Builds=$Sources/bin

for binfile in "$Builds"/*; do
  if [ -f "$binfile" ]; then
    rm "$Bin"/"$(basename "$binfile")"
  fi
done

rm -rf "$Sources"
