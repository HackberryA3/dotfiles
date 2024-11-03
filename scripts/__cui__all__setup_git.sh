#!/bin/bash
set -eu

cd "$(dirname "$0")" || exit 1
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh
log_info "Setting up git..." "GIT"

if ! (command -v "git" > /dev/null 2>&1); then
	log_warning "git is not installed, Please install it." "GIT" >&2
	exit
fi


git config --global init.defaultBranch main
git config --global pull.ff only

git config --global core.autocrlf false
git config --global core.quotepath false
git config --global core.ignorecase false
git config --global core.editor nvim

git config --global color.ui true
git config --global grep.lineNumber true

git config --global alias.graph "log --pretty=format:'%Cgreen[%cd] %Cblue%h %Cred<%cn> %Creset%s' --date=short  --decorate --graph --branches --tags --remotes --all"

if [ -z "${PS1-}" ]; then
	log_success "Git configuration is done (non-interactive)." "GIT"
	exit
fi

echo -n "Your email address for git : "
read -r email
git config --global user.email "$email"

echo -n "Your name for git : "
read -r name
git config --global user.name "$name"



log_success "Git configuration is done." "GIT"
