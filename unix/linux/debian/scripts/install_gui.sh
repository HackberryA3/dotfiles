#!/bin/bash

PWD=$(pwd)
cd "$(dirname "$0")" || (echo "Failed run script" && exit 1)

if [ -d "./gui/" ]; then
	find ./gui/ -type f -name "*.sh" -exec bash {} \;
fi

PARENT="$(dirname "$(dirname "$(pwd)")")/scripts/install_gui.sh"
if [ -e "$PARENT" ]; then
	chmod u+x "$PARENT"
	echo "Running parent script: $PARENT"
	bash "$PARENT"
fi

cd "$PWD" || exit
