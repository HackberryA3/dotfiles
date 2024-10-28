#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Installing Oh My Posh..." "OH MY POSH"

if ! (command -v "curl" > /dev/null 2>&1); then
	log_error "curl is not installed, Please install it." "OH MY POSH" >&2
	exit 1
fi

if [[ $(id -u) -eq 0 ]]; then
	curl -fsS https://ohmyposh.dev/install.sh | bash -s -- -d /usr/local/bin
else
	curl -fsS https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin
fi

log_success "Oh My Posh has been installed successfully." "OH MY POSH"
