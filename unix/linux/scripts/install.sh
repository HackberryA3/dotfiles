#!/bin/bash -eu

PWD=$(pwd)
cd "$(dirname "$0")" || (echo "Failed run script" && exit 1)

# 引数を見て、--cuiならCUIのみ、--guiならGUIのみ、--dotfilesならdotfilesのみをインストール
# それ以外の引数なら全てをインストール
# 複数の引数を指定可能
CUI=0
GUI=0
DOTFILES=0
if [ $# -eq 0 ]; then
	CUI=1
	GUI=1
	DOTFILES=1
else
	for arg in "$@"; do
		case $arg in
			--cui)
				CUI=1
				;;
			--gui)
				GUI=1
				;;
			--dotfiles)
				DOTFILES=1
				;;
			*)
				echo "Invalid argument: $arg"
				echo "Usage: $0 [--cui] [--gui] [--dotfiles]"
				echo "  --cui: Install CUI apps only"
				echo "  --gui: Install GUI apps only"
				echo "  --dotfiles: Install dotfiles only (Create symbolic links)"
				echo "  If no argument is specified, all will be installed"
				exit 1
				;;
		esac
	done
fi

if [ $CUI -eq 1 ]; then
	if [ -d "./cui/" ]; then
		find ./cui/ -type f -name "*.sh" -exec bash {} \;
	fi
fi
if [ $GUI -eq 1 ]; then
	if [ -d "./gui/" ]; then
		find ./gui/ -type f -name "*.sh" -exec bash {} \;
	fi
fi
if [ $DOTFILES -eq 1 ]; then
	SCRIPT_DIR="$(pwd)"
	DOTFILES_DIR="$(dirname "$(pwd)")"
	cd "$DOTFILES_DIR" || (echo "Failed run script" && exit 1)

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

	cd "$SCRIPT_DIR" || (echo "Failed run script" && exit 1)
fi

PARENT_DIR="$(dirname "$(dirname "$(pwd)")")"
if [ -e "$PARENT_DIR/scripts/install.sh" ]; then
	bash "$PARENT_DIR/scripts/install.sh" "$@"
fi

cd "$PWD" || exit
