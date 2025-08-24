#!/bin/sh

# get all the variables and config files
# -- !! don't change this !! --
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source $SCRIPT_DIR/../config.sh
source <(curl -s https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/config.sh)
Package=$(basename "$SCRIPT_DIR")

# determine and install all dependencies for this package
# -- !! make sure all dependencies are in the repos !! --
Dependencies=("make")
get_dependencies

# define the code source URL
Code="https://github.com/pipeseroni/pipes.sh.git"

# make a home for the source code
# -- !! in the $Sources/$Package directory !! --
rm -rf $Sources/$Package
mkdir -p $Sources/$Package

# put the source code in its home
# -- !! in the $Sources/$Package directory !! --
git clone "$Code" "$Sources/$Package"
cd $Sources/$Package || exit

# specify builds directory
Builds="$Sources/$Package/uspmbuilds"
mkdir -p $Builds

# compile the binaries
make PREFIX=$Builds install
cp pipes.sh $Builds

# put all newly compiled binaries in $Bin
cp $Builds/* $Bin

# make the app's .desktop description
# -- !! only do this if it's an app, not just a cli program !! --
app_name="$Package"
app_comment="Wayland status bar"
app_exec_location="$Sources"/"$Package"/build/waybar
app_terminal="false"
app_type="Application"
app_categories="Status Bar;"

# make the app
# -- !! only do this if it's an app, not just a cli program !! --
make_app

# make a builds.sh file for the remove.sh script to source
echo "Builds=$Builds" >> "$install_location"/repo/"$Package"/builds.sh
