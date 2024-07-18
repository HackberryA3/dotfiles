#!/bin/bash
set -eu

echo "#####################"
echo "# Git configuration #"
echo "#####################"

if ! (which "git" > /dev/null 2>&1); then
	echo "git is not installed, Please install it."
	echo "#####################"
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

git config --global alias.graph "log --pretty=format:'%Cgreen[%cd] %Cblue%h %Cred<%cn> %Creset%s' --date=short  --decorate --graph --branches --tags --remotes"

if [ -z "${PS1-}" ]; then
	echo "Git configuration is done (non-interactive)."
	echo "#####################"
	exit
fi

echo -n "Your email address for git : "
read -r email
git config --global user.email "$email"

echo -n "Your name for git : "
read -r name
git config --global user.name "$name"



echo "Git configuration is done."
echo "#####################"
