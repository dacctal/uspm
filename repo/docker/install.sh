#!/bin/sh

Package="docker"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"
Clone="https://github.com/docker/docker-ce"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources"

git checkout v18.03.1-ce
make static DOCKER_BUILD_PKGS=static-linux
tar -xvf ./components/packaging/static/build/linux/docker*.tgz

cd -
