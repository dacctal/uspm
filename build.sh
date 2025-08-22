#!/bin/bash

echo "Building USPM and setting up local repository..."

gcc main.c -o uspm

echo "Setting up local repository..."
cp -r ./repo ~/.local/share/uspm/

mkdir -p ~/.local/share/uspm/bin/
mkdir -p ~/.local/share/uspm/sources/

mv uspm ~/.local/share/uspm/bin/
