#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
Package=$(basename "$SCRIPT_DIR")

Dependencies=("curl")
get_dependencies

Code="https://raw.githubusercontent.com/will8211/unimatrix/master/unimatrix.py"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

Builds="$Sources/$Package/uspmbuilds"
mkdir -p "$Builds"

curl -L "$Code" -o "$Builds"
chmod a+rx "$Builds"/*

cp $Builds/* $Bin

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
