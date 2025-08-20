#!/bin/sh

Package="otter-launcher"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/kuokuo123/otter-launcher"

rm -rf $Sources

git clone "$Clone" "$Sources"
cd "$Sources" || exit

cargo build --release
cp target/release/otter-launcher "$Bin"

cd -
