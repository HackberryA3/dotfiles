#!/bin/bash
set -eu

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Installing Bitwarden..." "BITWARDEN"

if ! (which "wget" > /dev/null 2>&1); then
	log_error "wget is not installed, Please install it." "BITWARDEN" >&2
	exit 1
fi

BITWARDEN="./bitwarden.deb"
wget --no-verbose -O $BITWARDEN "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb" -o /dev/stdout
apt-get -qq install $BITWARDEN -y
rm $BITWARDEN

log_success "Bitwarden has been installed successfully." "BITWARDEN"
