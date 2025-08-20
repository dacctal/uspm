#!/bin/sh

Package="cmake"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin"

sudo rm -rf "$Bin"/curl* "$Bin"/wcurl
sudo rm -rf "$Sources"
