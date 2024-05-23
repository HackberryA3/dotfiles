#!/bin/bash
set -e
set -u

echo "###############################"
echo "# Japanese input installation #"
echo "###############################"

apt-get install -y fcitx5-mozc

echo "このあと、再起動して、Input MethodにMozcを追加する"
echo "###############################"
