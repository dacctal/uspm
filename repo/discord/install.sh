#!/bin/sh

Dependencies=("curl")

for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done

Package="discord"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
App="$Bin"/applications/"$Package".desktop
Appln="$HOME/.local/share/applications/$Package.desktop"

rm -rf "$Sources"
rm "$Appln"
rm "$App"

mkdir -p "$Sources"
mkdir -p "$Bin"/applications
cd "$Sources"
curl -L "https://discord.com/api/download?platform=linux&format=tar.gz" -o discord.tar.gz

tar -xvzf discord.tar.gz

echo "[Desktop Entry]
Name=Discord
Comment=Discord chat client
Exec="$HOME"/.local/share/uspm/sources/discord/Discord/Discord
Terminal=false
Type=Application
Categories=Network;Chat;
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
