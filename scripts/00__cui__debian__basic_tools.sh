#!/bin/bash

echo "#######################"
echo "# Basic tools install #"
echo "#######################"

PWD=$(pwd)
cd "$(dirname "$0")" || (echo -e "\e[31mFaild run script\e[0m" >&2 && exit 1)

bash utils/apt.sh lists/__debian__basic_tools.list
STATUS=$?

cd "$PWD" || exit

echo -e "\e[32mBasic tools have been installed successfully.\e[0m"

exit $STATUS
