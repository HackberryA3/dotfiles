#!/bin/bash

echo "######################################"
echo "# Programming Languages installation #"
echo "######################################"

PWD=$(pwd)
cd "$(dirname "$0")" || (echo "Faild run script" && exit 1)

bash utils/apt.sh lists/__debian__pg_lang.list
STATUS=$?

cd "$PWD" || exit

echo -e "\e[32mProgramming Languages have been installed successfully.\e[0m"

exit $STATUS
