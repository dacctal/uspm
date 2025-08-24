#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
source (curl -s https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/config.sh)
Package=$(basename "$SCRIPT_DIR")

Dependencies=("cmake")
get_dependencies

Code="https://github.com/llvm/llvm-project.git"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

git checkout llvmorg-18.1.8

Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds
cd $Builds

cmake -G Ninja ../llvm \
  -DLLVM_ENABLE_PROJECTS="clang;lld;lldb" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$Builds"

ninja -j$(nproc)
ninja install

cp $Builds/* $Bin

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
