#!/bin/bash

VSCode="./vscode.deb"

wget -O $VSCode "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

sudo apt install $VSCode

rm $VSCode
