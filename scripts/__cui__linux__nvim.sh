#!/bin/bash
set -euo pipefail

echo "#######################"
echo "# Neovim installation #"
echo "#######################"

if ! (which "curl" > /dev/null 2>&1); then
	echo -e "\e[31mcurl is not installed, Please install it.\e[0m" >&2
	exit 1
fi

INSTALL_PATH="/usr/local/bin/nvim"
if [ -f ~/.local/bin/nvim ]; then
	echo "nvim is already installed."
	echo "So this script will update nvim."

	if [[ $(id -u) -eq 0 ]]; then
		rm $INSTALL_PATH
	else
		sudo rm $INSTALL_PATH
	fi
fi

if [[ $(id -u) -eq 0 ]]; then
	curl -Lsf https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o $INSTALL_PATH --create-dirs
	chmod +x $INSTALL_PATH
else 
	sudo curl -Lsf https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o $INSTALL_PATH --create-dirs
	sudo chmod +x $INSTALL_PATH
fi

echo -e "\e[32mnvim has been installed successfully.\e[0m"
