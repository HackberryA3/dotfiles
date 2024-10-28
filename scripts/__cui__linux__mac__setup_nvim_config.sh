#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Setting up nvim config..." "NVIM CONFIG"

if ! (command -v "git" > /dev/null 2>&1); then
	log_error "git is not installed, Please install it." "NVIM CONFIG" >&2
	exit 1
fi

CHOICE=false
while [[ $# -gt 0 ]]; do
	case $1 in
		--choice)
			CHOICE=true
			;;
	esac
	shift
done

cd ~ || exit 1
if [ -d ".config/nvim" ]; then
	if [ "$CHOICE" = false ]; then
		log_warning "nvim config is already set up." "NVIM CONFIG" >&2
		exit
	fi

	# TODO: 質問プロンプトを実装する
	log_warning "nvim config is already set up. Do you want to overwrite it? [y/N]" "NVIM CONFIG"
	read -r -n1 answer
	if [[ ! "$answer" =~ ^[Yy]$ ]]; then
		log_info "nvim config setup is canceled." "NVIM CONFIG"
		exit
	fi

	rm -rf .config/nvim
fi

mkdir -p .config/
git clone https://github.com/hackberrya3/.dotfiles.nvim .config/nvim 2>&1

log_success "nvim config has been set up successfully." "NVIM CONFIG"
