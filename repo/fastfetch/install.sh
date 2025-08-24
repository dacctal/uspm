#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
source (curl -s https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/config.sh)
Package=$(basename "$SCRIPT_DIR")

Dependencies=("cmake")
get_dependencies

Code="https://github.com/fastfetch-cli/fastfetch.git"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds
cd $Builds

cmake ..
cmake --build . --target fastfetch

cp fastfetch "$Bin"

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
