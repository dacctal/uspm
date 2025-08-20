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

Package="gammastep"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://gitlab.com/chinstrap/gammastep.git"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources"

./bootstrap
./configure --prefix="$Sources" \
  --with-systemduserunitdir=$HOME/.config/systemd/user
make
make install

cp ./bin/gammastep* "$Bin"

cd -
