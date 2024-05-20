#!/bin/bash

PWD=$(pwd)
cd "$(dirname $0)"

grep -vE '^\s*$|^\s*#' -- cracking_tools.list | xargs -I APP apt install APP -y

cd ~
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git

cd $PWD
