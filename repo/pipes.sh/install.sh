#!/bin/sh

Package="pipes.sh"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/pipeseroni/pipes.sh.git"

rm -rf $Sources

git clone "$Clone" "$Sources"
cd "$Sources" || exit

make PREFIX=$Sources install
cp pipes.sh ~/.local/share/uspm/bin/pipes.sh

cd -
