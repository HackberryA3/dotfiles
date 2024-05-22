#!/bin/bash

echo "#######################"
echo "# VSCode installation #"
echo "#######################"

if ! (which "wget" > /dev/null 2>&1); then
	echo "wget is not installed, Please install it."
	echo "#######################"
	exit
fi

VSCODE="./vscode.deb"
wget -O $VSCODE "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
apt-get install $VSCODE
rm $VSCODE

echo "VSCode has been installed successfully."
echo "#######################"
