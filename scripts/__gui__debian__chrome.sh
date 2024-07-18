#!/bin/bash
set -eu

echo "#######################"
echo "# Chrome installation #"
echo "#######################"

if ! (which "wget" > /dev/null 2>&1); then
	echo "wget is not installed, Please install it."
	echo "#######################"
	exit 1
fi

CHROME="./chrome.deb"
wget -O $CHROME https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /dev/stdout
apt-get install $CHROME -y
rm $CHROME

echo "Chrome has been installed successfully."
echo "#######################"
