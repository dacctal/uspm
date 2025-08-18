if ! [ -f "~/.local/share/uspm/bin/curl" ]; then
  ~/.local/share/uspm/repo/curl/install.sh
fi

rm -rf ~/.local/share/uspm/sources/rust/ &&
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
