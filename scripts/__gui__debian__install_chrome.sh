#!/bin/bash
set -eu

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Installing Chrome..." "CHROME"

if ! (which "wget" > /dev/null 2>&1); then
	log_error "wget is not installed, Please install it." "CHROME" >&2
	exit 1
fi

CHROME="./chrome.deb"
wget --no-verbose -O $CHROME https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /dev/stdout
apt-get -qq install $CHROME -y
rm $CHROME

log_success "Chrome has been installed successfully." "CHROME"
