#!/bin/bash

gcc main.c -o uspm

cp -r ./repo ~/.local/share/uspm/

if ! [ -d "~/.local/share/uspm/bin/" ]; then
  mkdir ~/.local/share/uspm/bin/
fi

if ! [ -d "~/.local/share/uspm/sources/" ]; then
  mkdir ~/.local/share/uspm/sources/
fi

mv uspm ~/.local/share/uspm/bin/
