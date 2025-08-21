#!/bin/sh

Package="foot"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"
App="$HOME/.local/share/uspm/bin/applications/$Package.desktop"
Appln="$HOME/.local/share/applications/$Package.desktop"

sudo rm -rf "$Sources"
sudo rm -rf "$Bin"
rm "$App"
rm "$Appln"
