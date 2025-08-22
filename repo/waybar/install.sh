#!/bin/sh

Dependencies=("meson" "ninja")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="waybar"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://github.com/Alexays/Waybar"

rm -rf "$Sources"
rm "$Appln"
rm "$App"

git clone "$Clone" "$Sources"
cd "$Sources"

meson setup build
ninja -C build

cp build/waybar "$Bin"

echo "[Desktop Entry]
Name=Waybar
Comment=Wayland status bar
Exec="$Sources/build/waybar"
Terminal=false
Type=Application
" >>"$Bin"/applications/"$Package".desktop
chmod +x "$Bin"/applications/"$Package".desktop

mkdir -p ~/.local/share/applications
ln -s ~/.local/share/uspm/bin/applications/"$Package".desktop \
  ~/.local/share/applications/

echo "
--- IMPORTANT ---

This app's .desktop file is
installed in a custom location.

To make your app launcher
recognize this location, you
need to add the following
into ~/.profile

export XDG_DATA_DIRS="\$XDG_DATA_DIRS:\$HOME/.local/share/uspm/bin/"
"
