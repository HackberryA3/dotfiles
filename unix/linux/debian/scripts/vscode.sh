#!/bin/bash

VSCODE="./vscode.deb"
wget -O $VSCODE "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo apt install $VSCODE
rm $VSCODE
