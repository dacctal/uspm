#!/bin/sh

Package="python"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"

rm -rf "$Bin"
rm -rf "$Sources"

rm -rf /usr/local/bin/pydoc* ~/.local/share/uspm/bin/
rm -rf /usr/local/bin/idle* ~/.local/share/uspm/bin/
rm -rf /usr/local/bin/pip* ~/.local/share/uspm/bin/
