#!/bin/bash
set -eu

echo "#######################"
echo "# Chrome installation #"
echo "#######################"

if ! (which "wget" > /dev/null 2>&1); then
	echo -e "\e[31mwget is not installed, Please install it.\e[0m" >&2
	exit 1
fi

CHROME="./chrome.deb"
wget --no-verbose -O $CHROME https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /dev/stdout
apt-get -qq install $CHROME -y
rm $CHROME

echo -e "\e[32mChrome has been installed successfully.\e[0m"
