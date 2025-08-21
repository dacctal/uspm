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

git checkout llvmorg-18.1.8

mkdir build
cd build

cmake -G Ninja ../llvm \
  -DLLVM_ENABLE_PROJECTS="clang;lld;lldb" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$Sources/binaries"

ninja -j$(nproc)
ninja install

cd -
cd -
