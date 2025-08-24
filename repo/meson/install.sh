#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
Package=$(basename "$SCRIPT_DIR")

Dependencies=("python")
get_dependencies

Code="https://github.com/mesonbuild/meson.git"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds

python3 -m pip install --prefix="$Builds" .

cp "$Builds"/bin/meson "$Bin"

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
