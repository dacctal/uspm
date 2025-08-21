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

Package="foot"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
Clone="https://codeberg.org/dnkl/foot.git"

sudo rm -rf "$Sources"
rm "$Appln"
rm "$App"

git clone "$Clone" "$Sources"
cd "$Sources"

mkdir -p bld/release && cd bld/release

export CFLAGS="$CFLAGS -O3"
meson --prefix="$Sources"/bld/release \
  --buildtype=release \
  -Dcustom-terminfo-install-location="$Sources"/terminfo \
  ../..
ninja
ninja install

cp bin/* "$Bin"

echo "[Desktop Entry]
Name=Foot
Comment=Foo Terminal
Exec=/home/dacc/.local/share/uspm/bin/foot
Terminal=false
Type=Application
Categories=Terminal;
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
