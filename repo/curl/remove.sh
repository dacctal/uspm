#!/bin/sh

Package="curl"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"

sudo rm -rf "$Bin"
sudo rm -rf "$Sources"
