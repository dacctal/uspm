#!/bin/sh

Package="cmake"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin"

sudo rm "$Bin"/cmake "$Bin"/ccmake "$Bin"/cpack "$Bin"/ctest "$Bin"/ctresalloc
sudo rm -rf "$Sources"
