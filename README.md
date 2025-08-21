# uspm
uspm is a universal package manager that compiles each package from source. It's also limited to the user, so each person using the system has their own packages in the $PATH by default.

## Getting Started
> [!WARNING]
> Do NOT use this package manager with sudo or as root. It will not work as intended, and will most likely break your system. As said before, this package manager is for the USER. If, at any point, it needs to use sudo, it will do that on its own.

Working with uspm should be a breeze, as just typing `uspm` gives you all of its functionality in a concise and readable format.

Each command is very simple, and should be very easy to type (yes, this is a feature)

If you're looking for a package, you can look for it in the `repo` directory.
## Install
Run this command to install uspm:
```
curl https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/uspm/install.sh | sh
```

This script tries to add uspm to your `$PATH` using `~/.profile`. Make sure it's sourced in your shell's config (examples: `.bashrc`, `.zshrc`):
```
source ~/.profile
```
