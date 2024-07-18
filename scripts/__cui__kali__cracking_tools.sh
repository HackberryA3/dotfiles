#!/bin/bash

echo "##########################"
echo "# Cracking tools install #"
echo "##########################"

PWD=$(pwd)
cd "$(dirname "$0")" || (echo "Faild run script" && exit 1)

bash utils/apt.sh lists/__kali__cracking_tools.list

cd ~ || exit 1
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git

cd "$PWD" || exit

echo "Cracking tools have been installed successfully."
echo "##########################"
