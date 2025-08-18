#!/bin/sh

rm -rf ~/.local/share/uspm/sources/python/

git clone https://github.com/python/cpython.git ~/.local/share/uspm/sources/python/
cd ~/.local/share/uspm/sources/python/

./configure make make test
sudo make install

sudo mv /usr/local/bin/idle* ~/.local/share/uspm/bin/
sudo mv /usr/local/bin/pip* ~/.local/share/uspm/bin/
sudo mv /usr/local/bin/pydoc* ~/.local/share/uspm/bin/
sudo mv /usr/local/bin/python* ~/.local/share/uspm/bin/

cd -
