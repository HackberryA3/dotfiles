#!/bin/bash

echo "#####################"
echo "# Dev tools install #"
echo "#####################"

PWD=$(pwd)
cd "$(dirname "$0")" || (echo -e "\e[31mFaild run script\e[0m" >&2 && exit 1)

bash utils/apt.sh lists/__debian__dev_tools.list
STATUS=$?

cd "$PWD" || exit

echo -e "\e[32mDev tools have been installed successfully.\e[0m"

exit $STATUS
