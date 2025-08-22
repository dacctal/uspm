#!/bin/sh

Dependencies=("")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="make"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"

rm -rf "$Sources"

mkdir "$Sources"
cd "$Sources"
wget https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz

mkdir make
tar -xvzf make*.tar.gz -C make --strip-components=1
cd make

./configure
./build.sh

cp make "$Bin"
