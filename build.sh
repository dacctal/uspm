#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SCRIPT_DIR/repo/config.sh

echo "Making uspm directories..."
mkdir -p "$Bin"
mkdir -p "$Sources"
echo "uspm directories created"

echo "
uspm has 3 options for repositories:"
echo "Local, Online, & Dev Mode"
echo "Local is much faster, but online doesn't take up any storage on your machine (local repos will probably only ever be 1-5 gigabytes at most)."
echo "Do you want to store local repositories? [y/n/d]"
read isLocalRepos

if [ "$isLocalRepos" = "y" ]; then
  echo "(Local) Setting up local repository..."
  mv ./repo "$install_location"
  echo "NOTE: uspm still uses online repositories in
  the event that local repos don't work"
elif [ "$isLocalRepos" = "d" ]; then
  echo "(Dev Mode) Keeping git repos & generating system repos"
  cp -r ./repo "$install_location"
else
  echo "(Online) uspm will only use online repositories"
  rm -rf ./repo
fi

gcc main.c -o uspm

mv uspm ~/.local/share/uspm/bin/
