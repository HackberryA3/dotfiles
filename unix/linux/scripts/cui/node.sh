#!/bin/bash
set -e
set -u

echo "########################"
echo "# Node.js installation #"
echo "########################"

if which "nvm" > /dev/null 2>&1; then
	echo "nvm is already installed."

	if [ "${NVM_DIR}" ]; then
		(cd "${NVM_DIR}" && git pull)
	else
		echo "nvm directory is not found. Please update manually."
		echo "You can update nvm by running 'cd ${NVM_DIR} && git pull'"
	fi

	echo "########################"
	exit
fi
if ! (which "curl" > /dev/null 2>&1); then
	echo "curl is not installed, Please install it."
	echo "########################"
	exit 1
fi
if ! (which "jq" > /dev/null 2>&1); then
	echo "jq is not installed, Please install it."
	echo "########################"
	exit 1
fi

# rcに書き込まないようにする
export PROFILE="/dev/null"

LATEST=$(curl  "https://api.github.com/repos/nvm-sh/nvm/tags" | jq -r '.[0].name')
INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/$LATEST/install.sh"
echo "Installing nvm from $INSTALL_URL"
curl -fsSL -o- "$INSTALL_URL" | bash 

echo ""
echo "nvm is installed, Please run 'source ~/.bashrc' to use nvm."
echo "You can install nodejs using 'nvm install <version>' command."
echo "########################"
