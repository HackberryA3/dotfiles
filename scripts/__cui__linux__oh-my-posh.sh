#!/bin/bash
set -euo pipefail

echo "###########################"
echo "# Oh My Posh installation #"
echo "###########################"

if ! (which "curl" > /dev/null 2>&1); then
	echo "curl is not installed, Please install it."
	echo "###########################"
	exit 1
fi

if [[ $(id -u) -eq 0 ]]; then
	curl -fs https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin
else
	curl -fs https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin
fi

echo "Oh My Posh has been installed successfully."
echo "###########################"
