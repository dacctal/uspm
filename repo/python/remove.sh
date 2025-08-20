#!/bin/sh

Package="python"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"

rm -rf "$Bin"/idle*
rm -rf "$Bin"/python*
rm -rf "$Bin"/pydoc*
rm -rf "$Bin"/pip*
rm -rf "$Sources"
