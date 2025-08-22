#!/bin/sh

Dependencies=("meson")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="pipemixer"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Link="https://github.com/heather7283/pipemixer"

rm -rf $Sources

git clone "$Link" "$Sources"
cd "$Sources" || exit

meson setup build
meson compile -C build
cp build/pipemixer "$Bin"
