#!/bin/bash

echo "Do you want to use local repository? (Y/N)"
read -r use_local

gcc main.c -o uspm

if [ "$use_local" = "Y" ] || [ "$use_local" = "y" ]; then
    echo "Setting up local repository..."
    cp -r ./repo ~/.local/share/uspm/
else
    echo "Setting up online repository mode..."
    # Create repo directory but don't copy local files
    mkdir -p ~/.local/share/uspm/repo
fi

mkdir -p ~/.local/share/uspm/bin/
mkdir -p ~/.local/share/uspm/sources/

mv uspm ~/.local/share/uspm/bin/
