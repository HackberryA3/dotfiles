#!/bin/bash
cd `dirname $0`
sudo apt install $(cat tools.list | tr "\n" " ") -y

cd ~
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git
