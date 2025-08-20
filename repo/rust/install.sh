#!/bin/sh

Dependencies=("curl")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="rust"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
