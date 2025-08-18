rm -rf ~/.local/share/uspm/sources/yad/ &&
  git clone https://github.com/v1cont/yad.git ~/.local/share/uspm/sources/yad/ &&
  cd ~/.local/share/uspm/sources/yad/ &&
  autoreconf -ivf && intltoolize &&
  ./configure && make && sudo make PREFIX=$HOME/.local/share/uspm/sources/yad install &&
  gtk-update-icon-cache &&
  cd -
