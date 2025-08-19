#!/bin/bash

BinDir="$HOME/.local/share/uspm/bin"
RepoDir="$HOME/.local/share/uspm/repo"

# Use find to list only regular files in BinDir
find "$BinDir" -type f | while read -r FILE; do
  echo "$FILE is a file"

  PackageName=$(basename "$FILE")
  echo "$FILE assigned to $PackageName"

  InstallDir="$RepoDir/$PackageName"
  ScriptName="install.sh"

  if [ -x "$InstallDir/$ScriptName" ]; then
    echo "Running $InstallDir/$ScriptName"
    "$InstallDir/$ScriptName"
  else
    echo "No install script found for $PackageName"
  fi
done
