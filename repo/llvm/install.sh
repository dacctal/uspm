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

Package="llvm"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/llvm/llvm-project.git"

rm -rf $Sources

git clone "$Clone" "$Sources"
cd "$Sources"

mkdir builddir
cd builddir

cmake "$Sources"
cmake --build .
cmake -DCMAKE_INSTALL_PREFIX="$Sources"/bin -P cmake_install.cmake
cmake --build . --target install

cd -
cd -
