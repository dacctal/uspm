#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
source (curl -s https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/config.sh)
Package=$(basename "$SCRIPT_DIR")

Dependencies=("ninja" "meson")
get_dependencies

Code="git://anongit.freedesktop.org/git/cairo"
Code2="git://anongit.freedesktop.org/git/pixman.git"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
git clone "$Code2" "$Sources/$Package"
cd "$Sources" || exit

Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds

meson setup $Builds
ninja -C $Builds
ninja -C $Builds install
mkdir -p "$(dirname "$Bin")"

cp $Builds/* $Bin
sudo cp /usr/local/bin/cairo-trace ~/.local/share/uspm/bin/
sudo cp /usr/bin/cairo-trace ~/.local/share/uspm/bin/

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
