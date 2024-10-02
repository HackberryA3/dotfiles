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

BITWARDEN="/usr/local/bin/bitwarden"
if [[ $(id -u) -ne 0 ]]; then
	sudo wget --no-verbose -O $BITWARDEN "https://vault.bitwarden.com/download/?app=desktop&platform=linux" -o /dev/stdout
	sudo chmod +x $BITWARDEN
else
	wget --no-verbose -O $BITWARDEN "https://vault.bitwarden.com/download/?app=desktop&platform=linux" -o /dev/stdout
	chmod +x $BITWARDEN
fi

log_success "Bitwarden has been installed successfully." "BITWARDEN"
