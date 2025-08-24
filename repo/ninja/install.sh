#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
Package=$(basename "$SCRIPT_DIR")

Dependencies=("python")
get_dependencies

Code="https://github.com/ninja-build/ninja.git"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds

git checkout release
cat README.md
python3 configure.py
cmake -Bbuild-cmake -DBUILD_TESTING=OFF
cmake --build "$Builds"

cp "$Builds"/ninja "$Bin"

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
