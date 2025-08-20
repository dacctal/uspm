#!/bin/sh

Dependencies=("ninja" "meson")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="fuzzel"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://codeberg.org/dnkl/fuzzel.git"

rm -rf $Sources

git clone "$Clone" "$Sources"
cd "$Sources"

mkdir -p bld/release && cd bld/release
meson --buildtype=release --prefix="$Sources" \
  ../..
ninja
ninja install

cp fuzzel "$Bin"

echo "[Desktop Entry]
Name=Fuzzel
Comment=Fuzzel app launcher
Exec=/home/dacc/.local/share/uspm/bin/fuzzel
Terminal=false
Type=Application
Categories=App Launcher;
" >>"$Bin"/applications/"$Package".desktop
chmod +x "$Bin"/applications/"$Package".desktop

cd -
cd -

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
