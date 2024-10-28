#!/bin/bash
set -eu

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Installing lazygit..." "LAZYGIT"

if ! (command -v "curl" > /dev/null 2>&1); then
	log_error "curl is not installed, Please install it." "LAZYGIT" >&2
	exit 1
fi
if ! (command -v "tar" > /dev/null 2>&1); then
	log_error "tar is not installed, Please install it." "LAZYGIT" >&2
	exit 1
fi

LAZYGIT_VERSION=$(curl -sS "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -LsSo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
if [[ $(id -u) -eq 0 ]]; then
	mv lazygit /usr/local/bin/lazygit
	chmod +x /usr/local/bin/lazygit
else
	sudo mv lazygit /usr/local/bin
	sudo chmod +x /usr/local/bin/lazygit
fi
rm lazygit.tar.gz

log_success "Lazygit has been installed successfully." "LAZYGIT"
