#!/bin/bash

echo "#####################"
echo "# Dev tools install #"
echo "#####################"

PWD=$(pwd)
cd "$(dirname "$0")" || (echo "Faild run script" && exit 1)

bash utils/apt.sh lists/__debian__dev_tools.list

cd "$PWD" || exit

echo "Dev tools have been installed successfully."
echo "#####################"
