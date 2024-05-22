#!/bin/bash

echo "##########################"
echo "# Japanese input install #"
echo "##########################"

pacman -S noto-fonts-cjk -y
pacman -S fcitx5-mozc -y

echo "After reboot, add Mozc to Input Method"
echo "##########################"
