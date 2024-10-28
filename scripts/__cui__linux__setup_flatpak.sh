#!/bin/bash
set -eu

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Setting up flatpak..." "FLATPAK"

if ! (command -v "flatpak" > /dev/null 2>&1); then
	log_error "Flatpak is not installed, Please install it." "FLATPAK" >&2
	exit
fi

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

log_success "Flatpak has been set up successfully." "FLATPAK"
