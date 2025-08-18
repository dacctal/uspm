git clone https://gitlab.freedesktop.org/wayland/wayland ~/.local/share/uspm/sources/wayland &&
  cd ~/.local/share/uspm/sources/wayland &&
  meson build/ --prefix=~/.local/share/uspm/bin/wayland/ &&
  ninja -C build/ install &&
  cd -
