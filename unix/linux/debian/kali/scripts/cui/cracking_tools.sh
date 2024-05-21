#!/bin/bash

PWD=$(pwd)
cd "$(dirname "$0")" || (echo "Faild run script" && exit 1)

grep -vE '^\s*$|^\s*#' -- cracking_tools.list | xargs -I APP apt-get install APP -y

cd ~ || exit 1
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git

cd "$PWD" || exit
