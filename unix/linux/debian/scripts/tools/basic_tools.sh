#!/bin/bash

PWD=$(pwd)
cd "$(dirname $0)"

grep -vE '^\s*$|^\s*#' -- basic_tools.list | xargs -I APP apt-get install APP -y

cd $PWD
