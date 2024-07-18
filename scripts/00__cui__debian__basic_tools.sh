#!/bin/bash

echo "#######################"
echo "# Basic tools install #"
echo "#######################"

PWD=$(pwd)
cd "$(dirname "$0")" || (echo "Faild run script" && exit 1)

bash utils/apt.sh lists/__debian__basic_tools.list

cd "$PWD" || exit

echo "Basic tools have been installed successfully."
echo "#######################"
