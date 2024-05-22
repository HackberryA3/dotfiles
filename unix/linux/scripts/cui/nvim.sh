#!/bin/bash

echo "#######################"
echo "# Neovim installation #"
echo "#######################"

if ! (which "curl" > /dev/null 2>&1); then
	echo "curl is not installed, Please install it."
	echo "#######################"
	exit
fi

if [ -f ~/.local/bin/nvim ]; then
	echo "nvim is already installed."
	echo "So this script will update nvim."
	rm ~/.local/bin/nvim
fi

curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.local/bin/nvim --create-dirs

chmod u+x ~/.local/bin/nvim

echo "nvim has been installed successfully."
echo "#######################"
