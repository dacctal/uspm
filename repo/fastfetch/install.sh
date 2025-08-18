rm -rf ~/.local/share/uspm/sources/fastfetch/ &&
  git clone https://github.com/fastfetch-cli/fastfetch.git ~/.local/share/uspm/sources/fastfetch/ &&
  cd ~/.local/share/uspm/sources/fastfetch/ &&
  mkdir -p build &&
  cd build &&
  cmake .. &&
  cmake --build . --target fastfetch &&
  sudo cp fastfetch ~/.local/share/uspm/bin/ &&
  cd - &&
  cd -
