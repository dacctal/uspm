rm -rf ~/.local/share/uspm/sources/curl/ &&
  git clone https://github.com/stunnel/static-curl.git ~/.local/share/uspm/sources/curl/ &&
  cd ~/.local/share/uspm/sources/curl/ &&
  chmod +x curl-static-cross.sh &&
  sh curl-static-cross.sh &&
  cd -
