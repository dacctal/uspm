#!/bin/bash

for Package in "$HOME/.local/share/uspm/bin/"*; do
  PackageName=$(basename "$Package")

  if grep -qx "$PackageName" "$HOME/.local/share/uspm/repo/pkgs"; then
    "$HOME/.local/share/uspm/repo/$PackageName/install.sh"
  fi
done
