#!/bin/sh

if ! [ -f "~/.local/share/uspm/bin/rust" ]; then
  ~/.local/share/uspm/repo/rust/install.sh
fi

rm -rf ~/.local/share/uspm/sources/cairo/

git clone https://github.com/starkware-libs/cairo.git ~/.local/share/uspm/sources/cairo/
cd ~/.local/share/uspm/sources/cairo/

rustup override set stable rustup update
cargo test
cargo run --bin cairo-compile -- --single-file /path/to/input.cairo /path/to/output.sierra --replace-ids

cd -
