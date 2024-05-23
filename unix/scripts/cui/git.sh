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

if [ -z "$PS1" ]; then
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
