#!/bin/bash

PWD=$(pwd)
cd "$(dirname "$0")" || (echo "Failed run script" && exit 1)

if [ -d "./cui/" ]; then
	find ./cui/ -type f -name "*.sh" -exec bash {} \;
fi

PARENT="$(dirname "$(dirname "$(dirname "$0")")")/scripts/install_cui.sh"
if [ -e "$PARENT" ]; then
	chmod u+x "$PARENT"
	echo "Running parent script: $PARENT"
	bash "$PARENT"
fi

cd "$PWD" || exit
