#!/bin/sh

Dependencies=("python")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="meson"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/mesonbuild/meson.git"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources"

python3 -m pip install --prefix="$Sources" .
cp "$Sources"/bin/meson "$Bin"

cd -
