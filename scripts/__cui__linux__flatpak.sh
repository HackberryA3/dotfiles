#!/bin/bash
set -eu

echo "#########################"
echo "# Flatpak configuration #"
echo "#########################"

if ! (which "flatpak" > /dev/null 2>&1); then
	echo "Flatpak is not installed, Please install it"
	echo "#########################"
	exit
fi

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Flatpak configuration is done."
echo "#########################"
