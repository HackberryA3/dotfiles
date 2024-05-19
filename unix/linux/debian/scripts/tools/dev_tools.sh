#!/bin/bash

PWD=$(pwd)
cd $(dirname $0)

apt install $(cat dev_tools.list | tr '\n' ' ') -y

cd $PWD
