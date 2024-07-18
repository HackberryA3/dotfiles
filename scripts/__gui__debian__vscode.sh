#!/bin/bash
set -eu

echo "#######################"
echo "# VSCode installation #"
echo "#######################"

if ! (which "wget" > /dev/null 2>&1); then
	echo -e "\e[31mwget is not installed, Please install it.\e[0m" >&2
	exit 1
fi

VSCODE="./vscode.deb"
wget --no-verbose -O $VSCODE "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /dev/stdout
apt-get -qq install $VSCODE -y
rm $VSCODE

echo -e "\e[32mVSCode has been installed successfully.\e[0m"
