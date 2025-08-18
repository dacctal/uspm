# uspm
## Getting Started
Working with uspm should be a breeze, as just typing `uspm` gives you all of its functionality in a concise and readable format.

Each command is very simple, and should be very easy to type (yes, this is a feature)

If you're looking for a package, you can look for it in the `repo` directory.
## Install
Run this command to install uspm:
```
curl https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/uspm/install.sh | sh
```

Then, add the bin folder to your `$PATH`:
```
PATH=$PATH:~/.local/share/uspm/bin/ >> ~/.profile && source ~/.profile
```
