#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
Package=$(basename "$SCRIPT_DIR")

Dependencies=("make")
get_dependencies

Code="https://github.com/python/cpython.git"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds

./configure --prefix="$Builds"
make -j$(nproc)
make install

cp python "$Bin"
cp $Builds/bin/* $Bin

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
