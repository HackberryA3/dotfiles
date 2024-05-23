#!/bin/bash -e

echo "#######################"
echo "# Chrome installation #"
echo "#######################"

if ! (which "wget" > /dev/null 2>&1); then
	echo "wget is not installed, Please install it."
	echo "#######################"
	exit 1
fi

CHROME="./chrome.deb"
wget -O $CHROME https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install $CHROME
rm $CHROME

echo "Chrome has been installed successfully."
echo "#######################"
