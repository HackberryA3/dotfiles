#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Installing nvim..." "NVIM"

if ! (which "curl" > /dev/null 2>&1); then
	log_error "curl is not installed, Please install it." "NVIM" >&2
	exit 1
fi

INSTALL_PATH="/usr/local/bin/nvim"
if [ -f $INSTALL_PATH ]; then
	log_info "nvim is already installed. so trying to update..." "NVIM"

	if [[ $(id -u) -eq 0 ]]; then
		rm $INSTALL_PATH
	else
		sudo rm $INSTALL_PATH
	fi
fi

if [[ $(id -u) -eq 0 ]]; then
	curl -LsSf https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o $INSTALL_PATH --create-dirs
	chmod +x $INSTALL_PATH
else 
	sudo curl -LsSf https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o $INSTALL_PATH --create-dirs
	sudo chmod +x $INSTALL_PATH
fi

log_success "nvim has been installed successfully." "NVIM"
