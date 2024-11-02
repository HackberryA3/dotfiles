#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Installing nvim..." "NVIM"

if ! (command -v "curl" > /dev/null 2>&1); then
	log_error "curl is not installed, Please install it." "NVIM" >&2
	exit 1
fi
if ! (command -v "tar" > /dev/null 2>&1); then
	log_error "tar is not installed, Please install it." "NVIM" >&2
	exit 1
fi
if ! (command -v "gzip" > /dev/null 2>&1); then
	log_error "gzip is not installed, Please install it." "NVIM" >&2
	exit 1
fi

BINARY_PATH="/usr/local/bin/nvim"
TMP_PATH="/usr/local/lib/nvim-linux64.tar.gz"
INSTALL_PATH="/usr/local/lib/nvim-linux64"
LOCAL_BIN_PATH="$HOME/.local/bin/nvim"
LOCAL_TMP_PATH="$HOME/.local/lib/nvim-linux64.tar.gz"
LOCAL_INSTALL_PATH="$HOME/.local/lib/nvim-linux64"
if [[ $(id -u) -ne 0 ]]; then
	BINARY_PATH="$LOCAL_BIN_PATH"
	TMP_PATH="$LOCAL_TMP_PATH"
	INSTALL_PATH="$LOCAL_INSTALL_PATH"
fi

if [[ -e $INSTALL_PATH ]] || [[ -e $BINARY_PATH ]]; then
	log_info "nvim is already installed. so trying to update..." "NVIM"
	rm -rf "$INSTALL_PATH"
	[[ -f $BINARY_PATH ]] && rm -f "$BINARY_PATH"
	[[ -L $BINARY_PATH ]] && rm -f "$BINARY_PATH"
	[[ -f $TMP_PATH ]] && rm -f "$TMP_PATH"
fi

curl -LsSf https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -o "$TMP_PATH" --create-dirs
tar -xzf "$TMP_PATH" -C "$(dirname "$INSTALL_PATH")"
rm -f "$TMP_PATH"
ln -s "$INSTALL_PATH/bin/nvim" "$BINARY_PATH"

log_success "nvim has been installed successfully." "NVIM"
