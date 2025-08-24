#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
source (curl -s https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/config.sh)
Package=$(basename "$SCRIPT_DIR")

Dependencies=("make")
get_dependencies

Code="https://github.com/containerd/containerd.git"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

make

Builds="$Sources/$Package/bin"
cp $Builds/* $Bin

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
