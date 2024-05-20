#!/bin/bash

PWD=$(pwd)
cd "$(dirname $0)"

grep -vE '^\s*$|^\s*#' -- dev_tools.list | xargs -I APP apt install APP -y

cd $PWD
