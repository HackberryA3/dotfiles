#!/bin/bash
set -eu

echo "########################"
echo "# Lazygit installation #"
echo "########################"

if ! (which "curl" > /dev/null 2>&1); then
	echo "curl is not installed, Please install it."
	echo "########################"
	exit 1
fi
if ! (which "tar" > /dev/null 2>&1); then
	echo "tar is not installed, Please install it."
	echo "########################"
	exit 1
fi

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lso lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
if [[ $(id -u) -eq 0 ]]; then
	mv lazygit /usr/local/bin/lazygit
	chmod +x /usr/local/bin/lazygit
else
	sudo mv lazygit /usr/local/bin
	sudo chmod +x /usr/local/bin/lazygit
fi
rm lazygit.tar.gz

echo "Lazygit has been installed successfully."
echo "########################"
