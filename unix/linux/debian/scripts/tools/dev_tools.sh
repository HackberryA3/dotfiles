#!/bin/bash

PWD=$(pwd)
cd $(dirname $0)

sudo apt install $(cat dev_tools.list | tr '\n' ' ') -y

cd $PWD
