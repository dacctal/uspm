#!/bin/sh

if ! [ -f "~/.local/share/uspm/bin/docker" ]; then
  ~/.local/share/uspm/repo/docker/install.sh
fi

Package="curl"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/curl/curl.git"

rm -rf "$Sources"

git clone "$Clone" "$Sources"
cd "$Sources"

./buildconf
./configure --with-openssl --with-zlib --prefix="$Sources"
make -j$(nproc)
sudo make install
cp bin/* "$Bin"

cd -
