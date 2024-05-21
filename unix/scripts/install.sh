#!/bin/bash

PWD=$(pwd)
SCRIPT_DIR="$(dirname $0)"
DOTFILES_DIR="$(dirname $SCRIPT_DIR)"
cd $DOTFILES_DIR

for dotfile in .??*; do
	[ "$dotfile" = ".git" ] && continue
    [ "$dotfile" = ".gitignore" ] && continue
    [ "$dotfile" = ".gitconfig.local.template" ] && continue
    [ "$dotfile" = ".gitmodules" ] && continue
    [ "$dotfile" = ".DS_Store" ] && continue
	[ "$dotfile" = ".github" ] && continue

	if [ -L ~/$dotfile ]; then
		echo "Removing existing symlink: ~/$dotfile"
		unlink ~/$dotfile
	fi
	if [ -e ~/$dotfile ]; then
		if [ ! -d ~/.dotbackup ]; then
			mkdir ~/.dotbackup
		fi
		echo "Backing up existing file: ~/$dotfile"
		mv ~/$dotfile ~/.dotbackup/$dotfile.bak
	fi

	ln -snfv "$(pwd)/$dotfile" ~/$dotfile 
done

cd $PWD
