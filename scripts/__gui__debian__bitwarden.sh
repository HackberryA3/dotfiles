#!/bin/bash
set -eu

echo "##########################"
echo "# Bitwarden installation #"
echo "##########################"

if ! (which "wget" > /dev/null 2>&1); then
	echo "wget is not installed, Please install it."
	echo "##########################"
	exit 1
fi

BITWARDEN="./bitwarden.deb"
wget -O $BITWARDEN "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb" -o /dev/stdout
apt-get install $BITWARDEN
rm $BITWARDEN

echo "Bitwarden has been installed successfully."
echo "##########################"
