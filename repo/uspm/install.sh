#!/bin/sh

Package="uspm"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/dacctal/uspm.git"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources" || exit

echo "Building uspm..."
./build.sh
echo "Installing uspm..."
mkdir -p "$(dirname "$Bin")"
cp uspm "$Bin"

echo "Adding uspm to \$PATH..."
echo PATH=$PATH:~/.local/share/uspm/bin/ >>~/.profile && source ~/.profile

cd - || exit
