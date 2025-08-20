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

Package="ninja"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/ninja-build/ninja.git"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources"

git checkout release
cat README.md
python3 configure.py
cmake -Bbuild-cmake -DBUILD_TESTING=OFF
cmake --build build-cmake
cp build-cmake/ninja "$Bin"

cd -
