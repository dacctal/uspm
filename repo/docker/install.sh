#!/bin/sh

Dependencies=("runc containerd moby")

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
Code="https://github.com/docker/cli.git"

rm -rf $Sources

git clone $Code $Sources
cd $Sources

go mod init github.com/docker/cli
go mod tidy
rm -rf vendor
go get ./...
go build -v -o ./docker ./cmd/docker

mkdir bin
cp docker bin

Builds="$Sources/bin"

for binfile in "$Builds"/*; do
  if [ -f "$binfile" ]; then
    cp "$binfile" "$Bin"
  fi
done
