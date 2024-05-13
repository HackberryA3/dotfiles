#!/bin/bash
# Install bitwarden
cd ~
wget -O ./bitwarden.deb "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb"
sudo apt install ./bitwarden.deb
rm ./bitwarden.deb
