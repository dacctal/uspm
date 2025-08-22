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

Package="containerd"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Code="https://github.com/containerd/containerd.git"

rm -rf $Sources

git clone $Code $Sources
cd $Sources

make

Builds="$Sources/bin"

for binfile in "$Builds"/*; do
  if [ -f "$binfile" ]; then
    cp "$binfile" "$Bin"
  fi
done
