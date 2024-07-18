#!/bin/bash
set -euo pipefail

echo "###########################"
echo "# Oh My Posh installation #"
echo "###########################"

if ! (which "curl" > /dev/null 2>&1); then
	echo -e "\e[31mcurl is not installed, Please install it.\e[0m" >&2
	exit 1
fi

if [[ $(id -u) -eq 0 ]]; then
	curl -fsS https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin
else
	curl -fsS https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin
fi

echo -e "\e[32mOh My Posh has been installed successfully.\e[0m"
