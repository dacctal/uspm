#!/bin/sh

Dependencies=("runc containerd moby")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
source (curl -s https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/config.sh)
Package=$(basename "$SCRIPT_DIR")

Code="https://github.com/docker/cli.git"

rm -rf $Sources/$Package
mkdir -p $Sources/$Package

git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds

go mod init github.com/docker/cli
go mod tidy
rm -rf vendor
go get ./...
go build -v -o ./docker ./cmd/docker

cp docker $Builds

cp "$Builds"/bin/* "$Bin"

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
