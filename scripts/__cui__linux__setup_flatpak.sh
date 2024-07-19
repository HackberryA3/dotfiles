#!/bin/bash
set -eu

echo "#########################"
echo "# Flatpak configuration #"
echo "#########################"

if ! (which "flatpak" > /dev/null 2>&1); then
	echo -e "\e[31mFlatpak is not installed, Please install it.\e[0m" >&2
	exit
fi

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo -e "\e[32mFlatpak configuration is done.\e[0m"
