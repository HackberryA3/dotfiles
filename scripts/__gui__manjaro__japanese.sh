#!/bin/bash
set -e
set -u

echo "##########################"
echo "# Japanese input install #"
echo "##########################"

pacman -S noto-fonts-cjk -y
pacman -S fcitx5-mozc -y

echo -e "\e[33mAfter reboot, add Mozc to Input Method\e[0m" >&2
