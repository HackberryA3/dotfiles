#!/bin/bash
set -eu

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Installing Japanese input..." "JAPANESE INPUT"

if [[ $(id -u) -eq 0 ]]; then
	apt-get -qq install -y fcitx5-mozc
else
	sudo apt-get -qq install -y fcitx5-mozc
fi

log_success "Japanese input has been installed" "JAPANESE INPUT"
log_info "Settings are not finished yet!" "JAPANESE INPUT"
log_info "Please restart your computer and add Mozc to Input Method" "JAPANESE INPUT"
log_success "Japanese input has been installed" "JAPANESE INPUT" >&2
log_info "Settings are not finished yet!" "JAPANESE INPUT" >&2
log_info "Please restart your computer and add Mozc to Input Method" "JAPANESE INPUT" >&2
