#!/bin/sh



#-- List your dependencies here --#
#
Dependencies=("pkg1" "pkg2")
#
#-- Make sure all dependencies are already in the repo --#



#-- Do not touch --#
#
for Dep in ${Dependencies[@]}; do
  if ! [ -f "$HOME/.local/share/uspm/bin/$Dep" ]; then
    chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
    ~/.local/share/uspm/repo/$Dep/install.sh
  else
    echo "$Dep already installed"
  fi
done
#
#-- Do not touch --#



#-- Copy package name from parent directory --#
#
Package="templates"
#
#-- Copy package name from parent directory --#



#-- Do not touch --#
#
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"
#
#-- Do not touch --#



#-- git clone link --#
#
Clone="https://codeberg.org/dnkl/foot.git"
#
#-- only provide a url if you use --#
#-- git clone to acquire the package --#



#-- Do not touch --#
#
sudo rm -rf "$Sources"
rm "$Appln"
rm "$App"
#
#-- Do not touch --#



#-- clone into the sources directory --#
#
git clone "$Clone" "$Sources"
#
#-- if you don't use git, make --#
#-- sure you still download --#
#-- the source code in $Sources --#



#-- Do not touch --#
#
cd "$Sources"
#
#-- Do not touch --#



#-- build the package --#
#
make
make install
etc etc
#
#-- make sure to specify the build directory --#
#-- in $Sources when possible; otherwise, --#
#-- remove leftovers after install --#



#-- copy the package binaries --#
#-- to the $Bin --#
#
cp bin/* "$Bin"
#
#-- make sure all important --#
#-- binaries get to the $Bin --#



#-- generate .desktop file --#
#-- ONLY FOR APPLICATIONS, --#
#-- NOT CLI TOOLS --#
#
echo "[Desktop Entry]
Name=Template
Comment=A template of the install script
Exec=$HOME/.local/share/uspm/bin/$Package
Terminal=false
Type=Application
Categories=Example;" \
#
#-- generate .desktop file --#



#-- Do not touch --#
#
  >>"$Bin"/applications/"$Package".desktop
chmod +x "$Bin"/applications/"$Package".desktop
#
#-- Do not touch --#



#-- cd back to user's original dir --#
#
cd -
cd -
#
#-- however many cd's you do, --#
#-- that's how many of these you do --#



#-- relocate .desktop file & generate .desktop symlink --#
#-- ONLY FOR APPLICATIONS, --#
#-- NOT CLI TOOLS --#
#
mkdir -p ~/.local/share/applications
ln -s ~/.local/share/uspm/bin/applications/"$Package".desktop \
  ~/.local/share/applications/
#
#-- relocate .desktop file & generate .desktop symlink --#



#-- notify the user of the .desktop file --#
#-- ONLY FOR APPLICATIONS, --#
#-- NOT CLI TOOLS --#
#
echo "
--- IMPORTANT ---

This app's .desktop file is
installed in a custom location.

To make your app launcher
recognize this location, you
need to add the following
into ~/.profile

export XDG_DATA_DIRS="\$XDG_DATA_DIRS:\$HOME/.local/share/uspm/bin/""
#
#-- notify the user of the .desktop file --#



