#!/bin/bash
set -eu

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Installing VSCode..." "VSCode"

if ! (which "wget" > /dev/null 2>&1); then
	log_error "wget is not installed, Please install it." "VSCode" >&2
	exit 1
fi

VSCODE="./vscode.deb"
wget --no-verbose -O $VSCODE "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /dev/stdout
apt-get -qq install $VSCODE -y
rm $VSCODE

log_success "VSCode has been installed successfully." "VSCode"
