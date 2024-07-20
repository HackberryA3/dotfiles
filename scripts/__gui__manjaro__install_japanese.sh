#!/bin/bash
set -eu

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Installing Japanese input..." "JAPANESE INPUT"

pacman -S noto-fonts-cjk -y
pacman -S fcitx5-mozc -y

log_success "Japanese input has been installed" "JAPANESE INPUT" >&2
log_info "Settings are not finished yet!" "JAPANESE INPUT" >&2
log_info "Please restart your computer and add Mozc to Input Method" "JAPANESE INPUT" >&2
