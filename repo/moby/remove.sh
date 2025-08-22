#!/bin/sh

Package="moby"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"

Builds="$Sources/bundles/binary-daemon"

for binfile in "$Builds"/*; do
  if [ -f "$binfile" ]; then
    rm "$Bin"/"$(basename "$binfile")"
  fi
done

rm -rf $Sources
