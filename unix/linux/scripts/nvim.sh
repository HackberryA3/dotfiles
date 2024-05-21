#!/bin/bash

if ! (which "curl" > /dev/null 2>&1); then
	echo "curl is not installed, Please install it."
	exit
fi

if [ -f ~/.local/bin/nvim ]; then
	echo "nvim is already installed. Do you want to update it? (y/n)"
	read -n 1 -s -r	
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		exit
	fi

	rm ~/.local/bin/nvim
fi

curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/.local/bin/nvim --create-dirs

chmod u+x ~/.local/bin/nvim

echo "nvim has been installed successfully."
echo "You may need to install *node.js* and *unzip* too"
