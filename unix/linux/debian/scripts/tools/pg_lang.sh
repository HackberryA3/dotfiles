#!/bin/bash

PWD=$(pwd)
cd $(dirname $0)

apt install $(cat pg_lang.list | tr '\n' ' ') -y

cd $PWD
