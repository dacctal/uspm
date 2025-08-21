#!/bin/sh

#-- Copy package name from parent directory --#
#
Package="templates"
#
#-- Copy package name from parent directory --#

#-- Do not touch --#
#
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/$Package"
App="$HOME/.local/share/uspm/bin/applications/$Package.desktop"
Appln="$HOME/.local/share/applications/$Package.desktop"
#
#-- Do not touch --#

#-- delete every binary & source file --#
#
sudo rm -rf "$Sources"
sudo rm "$Bin"
rm "$App"
rm "$Appln"
#
#-- don't leave anything behind except config files --#
