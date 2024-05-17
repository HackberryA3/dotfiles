#!/bin/bash

PWD=$(pwd)
cd $(dirname $0)

sudo apt install $(cat pg_lang.list | tr '\n' ' ') -y

cd $PWD
