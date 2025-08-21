#!/bin/sh

Dependencies=("make")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="docker"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"

rm -rf "$Sources"

git clone https://github.com/moby/moby.git "$Sources"/moby
cd "$Sources"/moby

make binary

git clone https://github.com/docker/cli.git "$Sources"/cli

make -f docker.Makefile binary

install -Dm755 bundles/binary-daemon/dockerd "$Bin"
install -Dm755 cli/build/docker "$Bin"

git clone https://github.com/containerd/containerd.git "$Sources"/containerd
cd "$Sources"/containerd
make
install bin/containerd* "$Bin"

git clone https://github.com/opencontainers/runc.git "$Sources"/runc
cd "$Sources"/runc
make
install runc "$Bin"

