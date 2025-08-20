#!/bin/sh

Dependencies=("cmake")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="fastfetch"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/fastfetch-cli/fastfetch.git"

rm -rf $Sources

git clone "$Clone" "$Sources"
cd "$Sources"

mkdir -p build
cd build

cmake ..
cmake --build . --target fastfetch
sudo cp fastfetch "$Bin"

cd -
cd -
