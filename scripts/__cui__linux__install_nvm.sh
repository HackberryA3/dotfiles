#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Installing nvm..." "NVM"

if ! (which "git" > /dev/null 2>&1); then
	log_error "git is not installed, Please install it." "NVM" >&2
	exit 1
fi
if which "nvm" > /dev/null 2>&1; then
	log_info "nvm is already installed. so trying to update..." "NVM"

	if [ "${NVM_DIR}" ]; then
		(cd "${NVM_DIR}" && git pull)
	else
		log_warning "nvm directory is not found. Please update manually." "NVM" >&2
		log_warning "You can update nvm by running 'cd ${NVM_DIR} && git pull'" "NVM" >&2
	fi

	exit
fi
if ! (which "curl" > /dev/null 2>&1); then
	log_error "curl is not installed, Please install it." "NVM" >&2
	exit 1
fi
if ! (which "jq" > /dev/null 2>&1); then
	log_error "jq is not installed, Please install it." "NVM" >&2
	exit 1
fi

# rcに書き込まないようにする
export PROFILE="/dev/null"

LATEST=$(curl -sS "https://api.github.com/repos/nvm-sh/nvm/tags" | jq -r '.[0].name')
INSTALL_URL="https://raw.githubusercontent.com/nvm-sh/nvm/$LATEST/install.sh"
log_info "Installing nvm from $INSTALL_URL" "NVM"
curl -fsSL -o- "$INSTALL_URL" | bash 2>/dev/null

log_success "nvm is installed successfully." "NVM"
log_info "Please run 'source ~/.bashrc' to use nvm." "NVM"
log_info "You can install nodejs using 'nvm install <version>' command." "NVM"
log_success "nvm is installed successfully." "NVM" >&2
log_info "Please run 'source ~/.bashrc' to use nvm." "NVM" >&2
log_info "You can install nodejs using 'nvm install <version>' command." "NVM" >&2
