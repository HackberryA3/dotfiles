#!/bin/bash

PWD=$(pwd)
cd "$(dirname $0)"

apt install $(cat "cracking_tools.list" | tr "\n" " ") -y

cd ~
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git

cd $PWD
