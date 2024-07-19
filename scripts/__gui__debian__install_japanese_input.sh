#!/bin/bash
set -eu

echo "###############################"
echo "# Japanese input installation #"
echo "###############################"

if [[ $(id -u) -eq 0 ]]; then
	apt-get -qq install -y fcitx5-mozc
else
	sudo apt-get -qq install -y fcitx5-mozc
fi

echo -e "\e[33mまだ設定は終わっていません！\e[0m" >&2
echo -e "\e[33mこのあと、再起動して、Input MethodにMozcを追加する\e[0m" >&2
