#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
Package=$(basename "$SCRIPT_DIR")

Dependencies=("meson" "ninja")
get_dependencies

Code="https://codeberg.org/dnkl/foot.git"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds
cd $Builds

export CFLAGS="$CFLAGS -O3"
meson --prefix="$Builds" \
  --buildtype=release \
  -Dcustom-terminfo-install-location="$Sources"/"$Package"/terminfo \
  ..
ninja
ninja install

cp $Builds/* $Bin

App="$Bin"/applications/"$Package".desktop
Appln="$HOME/.local/share/applications/$Package.desktop"

app_name="foot"
app_comment="Foo Terminal"
app_exec_location="$Bin"/"$Package"
app_terminal="false"
app_type="Application"
app_categories="Terminal;"

make_app

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
