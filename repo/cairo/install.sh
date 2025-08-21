#!/bin/sh

Dependencies=("ninja" "meson")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="cairo"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="git://anongit.freedesktop.org/git/cairo"
Clone2="git://anongit.freedesktop.org/git/pixman.git"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
git clone "$Clone2" "$Sources"
cd "$Sources" || exit

meson setup $Sources/build
ninja -C $Sources/build
ninja -C $Sources/build install
mkdir -p "$(dirname "$Bin")"

sudo cp /usr/local/bin/cairo-trace ~/.local/share/uspm/bin/
sudo cp /usr/bin/cairo-trace ~/.local/share/uspm/bin/
