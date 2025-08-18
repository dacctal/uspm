#!/bin/bash

gcc main.c -o uspm
mv uspm ~/.local/share/uspm/bin/

cp -r ./repo ~/.local/share/uspm/

if ! [ -d "~/.local/share/uspm/bin/" ]; then
  mkdir ~/.local/share/uspm/bin/
fi
