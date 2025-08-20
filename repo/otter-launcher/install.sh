#!/bin/sh

Dependencies=("rust")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="otter-launcher"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/kuokuo123/otter-launcher"

rm -rf $Sources

git clone "$Clone" "$Sources"
cd "$Sources" || exit

cargo build --release
cp target/release/otter-launcher "$Bin"

cd -
