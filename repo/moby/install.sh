#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
Package=$(basename "$SCRIPT_DIR")

Dependencies=("")
get_dependencies

Code="https://github.com/moby/moby"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

mkdir -p bundles
hack/make.sh binary

Builds="$Sources/bundles/binary-daemon"

for binfile in "$Builds"/*; do
  if [ -f "$binfile" ]; then
    cp "$binfile" "$Bin"
  fi
done

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
