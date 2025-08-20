#!/bin/sh

Package="ninja"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin"

sudo rm -rf "$Bin"
sudo rm -rf "$Sources"
