#!/bin/sh

# - define config.toml
USPM_CONFIG_DIR=$HOME/.config/uspm
USPM_CONFIG="$USPM_CONFIG_DIR"/config.toml
mkdir -p "$USPM_CONFIG_DIR"

# - read config.toml
section=""
while IFS='=' read -r key value; do
  # section headers
  if [[ $key =~ ^\[.*\]$ ]]; then
    section="${key#[}"
    section="${section%]}"
    continue
  fi

  [[ -z $key || $key =~ ^# ]] && continue

  key=$(echo "$key" | xargs)
  value=$(echo "$value" | xargs)
  value=${value%\"}
  value=${value#\"}

  if [[ -n $section ]]; then
    declare "${section}_${key}=$value"
  else
    declare "$key=$value"
  fi
done <"$USPM_CONFIG"

# - configure
uspm_root() {
  echo "Do you want to root uspm? [ EXPERIMENTAL] [y/n]"
  read isRootedPhantom

  if [ "$isRootedPhantom" = "y" ]; then
    echo " Are you really sure you want to root uspm?  [y/n]"
    read isRooted
  else
    echo "uspm is not rooted"
  fi

  if [ "$isRooted" = "y" ]; then
    system_root="true"
  else
    system_root="false"
  fi

  echo "uspm config location: $USPM_CONFIG"
  echo "upsm installed to root: $system_root"
}

# - setup
if [ "$system_root" = "true" ]; then
  install_location="/usr/share/uspm"
  echo "using sudo, you may need to enter your password"
  sudo mkdir -p $install_location
  Appln="/usr/share/applications/$app_name.desktop"
  echo "uspm is rooted: $install_location"
  USPM_CONFIG="$install_location"/.config/config.toml
  sudo mkdir -p $install_location/.config
  echo "uspm is using root config: $USPM_CONFIG"
elif [ "$system_root" = "false" ]; then
  install_location="$HOME/.local/share/uspm"
  mkdir -p $install_location
  Appln="$HOME/.local/share/applications/$app_name.desktop"
  echo "uspm is in userspace: $install_location"
  USPM_CONFIG=$install_location/.config/uspm/config.toml
  echo "uspm is using local config: $USPM_CONFIG"
else
  echo "config file is written incorrectly.
  defaulting to userspace."
  install_location="$HOME/.local/share/uspm"
  mkdir -p $install_location
  Appln="$HOME/.local/share/applications/$app_name.desktop"
  echo "uspm is in userspace: $install_location"
  USPM_CONFIG=$install_location/config.toml
  echo "uspm is using local config: $USPM_CONFIG"
fi

if [ "$system_localrepos" = "false" ]; then
  rm -rf $system_localrepos/repo
  echo "uspm is using online repos exclusively:"
  echo "https://github.com/dacctal/uspm/tree/main/repo"
else
  echo "uspm is using local repos (online repos as a fallback)"
  echo "local: $install_location/repo"
  echo "online: https://github.com/dacctal/uspm/tree/main/repo"
fi

# - vars
Sources="$install_location/sources"
Bin="$install_location/bin"
App="$Bin"/applications/"$app_name".desktop

# - funcs
get_dependencies() {
  for Dep in ${Dependencies[@]}; do
    if ! [ -f "$Bin/$Dep" ]; then
      chmod +x ~/.local/share/uspm/repo/$Dep/install.sh
      ~/.local/share/uspm/repo/$Dep/install.sh
    else
      echo "$Dep already installed"
    fi
  done
}

remove_package() {
  for binfile in "$Builds"/*; do
    if [ -f "$binfile" ]; then
      rm "$Bin"/"$(basename "$binfile")"
    fi
  done

  rm -rf "$Sources/$Package"
  rm "$App"
  rm "$Appln"
}

make_app() {
  App="$Bin"/applications/"$app_name".desktop
  rm "$Appln"
  rm "$App"

  echo "[Desktop Entry]
Name=$app_name
Comment=$app_comment
Exec=$app_exec_location
Terminal=$app_terminal
Type=$app_type
Categories=$app_categories
  " >> "$App"
  chmod +x "$App"

  mkdir -p ~/.local/share/applications
  ln -s "$App" \
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
}
