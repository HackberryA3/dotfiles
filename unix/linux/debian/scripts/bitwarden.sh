#!/bin/bash

BITWARDEN="./bitwarden.deb"
wget -O $BITWARDEN "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb"
apt-get install $BITWARDEN
rm $BITWARDEN
