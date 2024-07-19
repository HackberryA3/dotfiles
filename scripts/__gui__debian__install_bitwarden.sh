#!/bin/bash
set -eu

echo "##########################"
echo "# Bitwarden installation #"
echo "##########################"

if ! (which "wget" > /dev/null 2>&1); then
	echo -e "\e[31mwget is not installed, Please install it.\e[0m" >&2
	exit 1
fi

BITWARDEN="./bitwarden.deb"
wget --no-verbose -O $BITWARDEN "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb" -o /dev/stdout
apt-get -qq install $BITWARDEN -y
rm $BITWARDEN

echo -e "\e[32mBitwarden has been installed successfully.\e[0m"
