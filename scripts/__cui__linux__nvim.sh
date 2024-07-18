#!/bin/bash
set -euo pipefail

echo "#######################"
echo "# Neovim installation #"
echo "#######################"

if ! (which "curl" > /dev/null 2>&1); then
	echo "curl is not installed, Please install it."
	echo "#######################"
	exit 1
fi

if [ -f ~/.local/bin/nvim ]; then
	echo "nvim is already installed."
	echo "So this script will update nvim."
	rm ~/.local/bin/nvim
fi

INSTALL_PATH="/usr/local/bin/nvim"
if [[ $(id -u) -eq 0 ]]; then
	curl -Lsf https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o $INSTALL_PATH --create-dirs
	chmod +x $INSTALL_PATH
else 
	sudo curl -Lsf https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o $INSTALL_PATH --create-dirs
	sudo chmod +x $INSTALL_PATH
fi

echo "nvim has been installed successfully."
echo "#######################"
