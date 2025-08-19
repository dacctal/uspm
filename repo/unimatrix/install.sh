#!/bin/sh

Package="unimatrix"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"

if ! [ -f "~/.local/share/uspm/bin/curl" ]; then
  ~/.local/share/uspm/repo/curl/install.sh
fi

rm -rf $Sources

curl -L https://raw.githubusercontent.com/will8211/unimatrix/master/unimatrix.py -o $Bin
chmod a+rx $Bin
