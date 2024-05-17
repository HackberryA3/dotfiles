#!/bin/bash

PWD=$(pwd)
cd $(dirname $0)

sudo apt install $(cat basic_tools.list | tr '\n' ' ') -y

cd $PWD
