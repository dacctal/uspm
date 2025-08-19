#!/bin/sh

if ! [ -f "~/.local/share/uspm/bin/docker" ]; then
  ~/.local/share/uspm/repo/docker/install.sh
fi

Package="curl"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"
Clone="https://github.com/stunnel/static-curl.git"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources"

chmod +x curl-static-cross.sh
sh curl-static-cross.sh

cd -
