rm -rf ~/.local/share/uspm/sources/pipes.sh/ &&
  git clone https://github.com/pipeseroni/pipes.sh.git ~/.local/share/uspm/sources/pipes.sh/ &&
  cd ~/.local/share/uspm/sources/pipes.sh/ &&
  make PREFIX=$HOME/.local/share/uspm/sources/pipes.sh/ install &&
  cp pipes.sh ~/.local/share/uspm/bin/pipes.sh &&
  cd -
