#!/bin/bash
set -eu

echo "###############################"
echo "# Japanese input installation #"
echo "###############################"

if [[ $(id -u) -ne 0 ]]; then
	apt-get install -y fcitx5-mozc
else
	sudo apt-get install -y fcitx5-mozc
fi

echo "このあと、再起動して、Input MethodにMozcを追加する"
echo "###############################"
