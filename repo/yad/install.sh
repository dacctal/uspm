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

Package="yad"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/v1cont/yad.git"

rm -rf ~/.local/share/uspm/sources/yad/

git clone "$Clone" "$Sources"
cd "$Sources"

autoreconf -ivf intltoolize
./configure
make
sudo make PREFIX=$HOME/.local/share/uspm/sources/yad install
gtk-update-icon-cache

sudo mv /usr/local/bin/yad* "$Bin"

cd -
