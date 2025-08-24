#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
Package=$(basename "$SCRIPT_DIR")

Code="https://github.com/dacctal/uspm.git"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone $Code $Sources/$Package
cd $Sources/$Package || exit

echo "Building uspm..."
./build.sh
echo "uspm compiled!"

uspm_root

echo "Moving uspm to binaries directory..."
mkdir -p "$(dirname $Bin/$Package)"
cp uspm $Bin/$Package
echo "uspm moved!"

echo "Adding uspm to \$PATH..."
echo PATH=$PATH:~/.local/share/uspm/bin/ >>~/.profile && source ~/.profile
echo "added!"

echo "Generating config file..."
mkdir -p $HOME/.config/uspm/
echo "[system]
root = false
localrepos = true
" >> $HOME/.config/uspm/config.toml
echo "config file generated!"

echo "uspm is installed!"
