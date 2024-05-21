#!/bin/bash

PWD=$(pwd)
cd "$(dirname "$0")" || (echo "Failed run script" && exit 1)

if [ -e "./install_cui.sh" ]; then
	bash install_cui.sh
fi
if [ -e "./install_gui.sh" ]; then
	bash install_gui.sh
fi
if [ -e "./dotfiles.sh" ]; then
	bash dotfiles.sh
fi

cd "$PWD" || exit
