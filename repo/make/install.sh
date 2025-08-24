#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
source <(curl -s https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/config.sh)
Package=$(basename "$SCRIPT_DIR")

Dependencies=("gnu-coreutils")
get_dependencies

Code="https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

cd "$Sources/$Package"
wget "$Code"

Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds
tar -xvzf make*.tar.gz -C "$Builds" --strip-components=1
cd $Builds

./configure
./build.sh

cp make "$Bin"

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
