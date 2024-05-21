#!/bin/bash

PWD="$(pwd)"
SCRIPT_DIR="$(dirname "$0")"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
cd "$DOTFILES_DIR" || (echo "Faild run script" && exit 1)

for dotfile in .??*; do
	[ ! -e "$dotfile" ] && continue
	[ "$dotfile" = ".git" ] && continue
    [ "$dotfile" = ".gitignore" ] && continue
    [ "$dotfile" = ".gitconfig.local.template" ] && continue
    [ "$dotfile" = ".gitmodules" ] && continue
    [ "$dotfile" = ".DS_Store" ] && continue
	[ "$dotfile" = ".github" ] && continue

	if [ -L ~/"$dotfile" ]; then
		echo "Removing existing symlink: ~/$dotfile"
		unlink ~/"$dotfile"
	fi
	if [ -e ~/"$dotfile" ]; then
		if [ ! -d ~/.dotbackup ]; then
			mkdir ~/.dotbackup
		fi
		echo "Backing up existing file: ~/$dotfile"
		mv ~/"$dotfile" ~/.dotbackup/"$dotfile".bak
	fi

	ln -snfv "$(pwd)/$dotfile" ~/"$dotfile" 
done

PARENT="$(dirname "$(pwd)")/scripts/dotfiles.sh"
if [ -e "$PARENT" ]; then
	chmod u+x "$PARENT"
	echo "Running parent script: $PARENT"
	bash "$PARENT"
fi

cd "$PWD" || exit