#!/bin/sh

rm -rf ~/.local/share/uspm/sources/uspm/

git clone https://github.com/dacctal/uspm.git ~/.local/share/uspm/sources/uspm/
cd ~/.local/share/uspm/sources/uspm/

./build.sh
cp uspm ~/.local/share/uspm/bin/uspm

cd -
