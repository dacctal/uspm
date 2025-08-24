#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
Package=$(basename "$SCRIPT_DIR")

Dependencies=("make")
get_dependencies

Code="git://git.sv.gnu.org/coreutils"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds
cd $Builds

./bootstrap
./configure --prefix="$Builds"/build
make -j8
make install

cp $Builds/* $Bin

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
