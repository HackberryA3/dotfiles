#!/bin/bash

BITWARDEN="./bitwarden.deb"
wget -O $BITWARDEN "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb"
sudo apt install $BITWARDEN
rm $BITWARDEN
