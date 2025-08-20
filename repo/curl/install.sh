#!/bin/sh

Dependencies=("docker")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

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
