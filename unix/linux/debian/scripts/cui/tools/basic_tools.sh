#!/bin/bash

PWD=$(pwd)
cd "$(dirname "$0")" || (echo "Faild run script" && exit 1)

grep -vE '^\s*$|^\s*#' -- basic_tools.list | xargs -I APP apt-get install APP -y

cd "$PWD" || exit