#!/bin/bash

PWD=$(pwd)
cd "$(dirname $0)"

apt install $(cat "basic_tools.list" | tr '\n' ' ') -y

cd $PWD
