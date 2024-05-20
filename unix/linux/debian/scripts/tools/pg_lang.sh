#!/bin/bash

PWD=$(pwd)
cd "$(dirname $0)"

grep -vE '^\s*$|^\s*#' -- pg_lang.list | xargs -I APP sudo apt install APP -y

cd $PWD
