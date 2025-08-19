#!/bin/sh

Package="docker"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"

rm -rf "$Sources"

git clone https://github.com/moby/moby.git "$Sources"
cd "$Sources"
git clone https://github.com/docker/cli.git

make binary
make -f docker.Makefile binary

sudo install -Dm755 moby/bundles/binary-daemon/dockerd "$Bin"
sudo install -Dm755 cli/build/docker "$Bin"

git clone https://github.com/containerd/containerd.git
cd containerd
make
sudo install bin/containerd* "$Bin"

git clone https://github.com/opencontainers/runc.git
cd runc
make
sudo install runc "$Bin"

cd -
cd -
cd -
