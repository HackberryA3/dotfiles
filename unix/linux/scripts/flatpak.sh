#!/bin/bash

if ! (which "flatpak" > /dev/null 2>&1); then
	echo "Flatpak is not installed, Please install it"
	exit
fi

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
