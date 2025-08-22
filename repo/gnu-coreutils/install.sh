#!/bin/sh

Dependencies=("make")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="gnu-coreutils"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="git://git.sv.gnu.org/coreutils"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources"

./bootstrap
./configure --prefix="$Sources"/build
make -j8
make install

Builds="$HOME/.local/share/uspm/sources/gnu-coreutils/build/bin"

for binfile in "$Builds"/*; do
  if [ -f "$binfile" ]; then
    cp "$binfile" "$Bin"
  fi
done
