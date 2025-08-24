#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
source (curl -s https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/config.sh)
Package=$(basename "$SCRIPT_DIR")

Dependencies=("curl")
get_dependencies

rm -rf $Sources/$Package

mkdir -p $Sources/$Package
mkdir -p "$Bin"/applications
cd $Sources/$Package || exit

Builds="$Sources/$Package/uspmbuilds"
mkdir -p "$Builds"

curl -L "https://discord.com/api/download?platform=linux&format=tar.gz" -o discord.tar.gz
tar -xvzf discord.tar.gz

cp "$Sources"/"$Package"/Discord/Discord "$Builds"

App="$Bin"/applications/"$Package".desktop
Appln="$HOME/.local/share/applications/$Package.desktop"

app_name="discord"
app_comment="Discord chat client"
app_exec_location="$Sources"/"$Package"/Discord/Discord
app_terminal="false"
app_type="Application"
app_categories="Network;Chat;"

make_app

echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
