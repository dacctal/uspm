#!/bin/sh

Package="discord"
Sources="$HOME/.local/share/uspm/sources/$Package"
Bin="$HOME/.local/share/uspm/bin/"

rm -rf "$Sources"

mkdir -p "$Sources"
cd "$Sources"
curl -L "https://discord.com/api/download?platform=linux&format=tar.gz" -o discord.tar.gz

tar -xvzf discord.tar.gz
echo "#!/bin/sh
~/.local/share/uspm/sources/discord/Discord/Discord" >>discord
chmod +x discord
cp discord "$Bin"
sudo cp -r . /opt/discord

cd -
