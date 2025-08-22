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

Package="python"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/python/cpython.git"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources" || exit

./configure --prefix="$Sources"/build
make -j$(nproc)
make install

cp python "$Bin"
cp build/bin/* "$Bin"
