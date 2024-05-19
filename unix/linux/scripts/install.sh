#!/bin/bash

PWD=$(pwd)
SCRIPT_DIR=$(cd $(dirname $0); pwd)
DOTFILES_DIR=$(cd $(dirname $(pwd)); pwd)

for dotfile in .??*; do
	[ "$dotfile" = ".git" ] && continue
    [ "$dotfile" = ".gitignore" ] && continue
    [ "$dotfile" = ".gitconfig.local.template" ] && continue
    [ "$dotfile" = ".gitmodules" ] && continue
    [ "$dotfile" = ".DS_Store" ] && continue

	if [ -L ~/$dotfile ]; then
		echo "Removing existing symlink: ~/$dotfile"
		unlink ~/$dotfile
		rm ~/$dotfile
	fi
	if [ -e ~/$dotfile ]; then
		echo "Backing up existing file: ~/$dotfile"
		mv ~/$dotfile ~/.dotbackup/$dotfile.bak
	fi

	ln -snfv "$(pwd)/$dotfile" ~/$dotfile 
done

PARENT=$(dirname $DOTFILES_DIR)/scripts/install.sh
if [ -f $PARENT ]; then
	chmod +x $PARENT
	echo "Running parent script: $PARENT"
	bash $PARENT
fi

cd $PWD
