#!/bin/sh

Package="python"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"
Clone="https://github.com/python/cpython.git"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources" || exit

./configure
make
make test
sudo make install

sudo mv /usr/local/bin/idle* ~/.local/share/uspm/bin/
sudo mv /usr/local/bin/pip* ~/.local/share/uspm/bin/
sudo mv /usr/local/bin/pydoc* ~/.local/share/uspm/bin/
sudo mv /usr/local/bin/python* ~/.local/share/uspm/bin/

cd -
