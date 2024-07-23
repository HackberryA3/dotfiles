#!/bin/bash
set -euo pipefail 

pushd "$(pwd)" >/dev/null || (echo -e "\e[31mFailed pushd\e[0m" >&2 && exit 1)
cd "$(dirname "$0")" || (echo -e "\e[31mFaild run script\e[0m" >&2 && exit 1)

# デフォルト値
OS=""
CUI=false
GUI=false
CHOICE=false
INSTALL_DOTFILES=false

. lib/utility.sh
. lib/ui/choose.sh
. lib/ui/log.sh

#Usage
# 関数: 使用方法を表示
function usage {
	echo "Usage: $0 [OPTIONS] OS" >&2
	echo "Options:" >&2
	echo "  -h, --help: Show this help message and exit" >&2
	echo "  --choice(default): Choose the installation script interactively" >&2
	echo "  --dotfiles: Install dotfiles" >&2
	echo "  --cui: Install CUI applications" >&2
	echo "  --gui: Install GUI applications" >&2
	echo "  --all: Install all applications" >&2
	echo "OS:" >&2
	echo "  linux" >&2
	echo "  ├─debian" >&2
	echo "  | ├─kali" >&2
	echo "  | └─ubuntu" >&2
	echo "  └─arch" >&2
	echo "    └─manjaro" >&2
	echo "  mac" >&2
	echo "  win" >&2
}

# 関数: スプラッシュを表示
function splash {
	echo -e "$(fgreen)" \
			" _   _            _    _                             _    _____  \n" \
			"| | | | __ _  ___| | _| |__   ___ _ __ _ __ _   _   / \  |___ /  \n" \
			"| |_| |/ _\` |/ __| |/ / '_ \ / _ \ '__| '__| | | | / _ \   |_ \  \n" \
			"|  _  | (_| | (__|   <| |_) |  __/ |  | |  | |_| |/ ___ \ ___) | \n" \
			"|_| |_|\__,_|\___|_|\_\_.__/ \___|_|  |_|   \__, /_/   \_\____/  \n" \
			"                                            |___/                $(normal)"
	echo -e "$(fmagenta)" \
			"                    _       _    __ _ _\n" \
			"                  _| | ___ | |_ / _(_) | ___  ___\n" \
			"                / _\` |/ _ \| __| |_| | |/ _ \/ __|\n" \
			"               | (_| | (_) | |_|  _| | |  __/\__ \ \n" \
			"              (_)__,_|\___/ \__|_| |_|_|\___||___/$(normal)\n"
}



# 引数の解析
while [[ $# -gt 0 ]]; do
    case $1 in
		--choice)
			CHOICE=true
			CUI=true
			GUI=true
			INSTALL_DOTFILES=true
			;;
        --dotfiles)
            INSTALL_DOTFILES=true
;;
        --cui)
			CUI=true
            ;;
        --gui)
			GUI=true
            ;;
        --all)
			CUI=true
			GUI=true
			INSTALL_DOTFILES=true
            ;;
		-h | --help)
			usage
			exit 0
			;;
        *)
			OS="$(to_lower "$1")"
            ;;
    esac
    shift
done
# もし何もオプションが指定されていない場合、choiceにする
if [[ "$CUI" == false && "$GUI" == false && "$INSTALL_DOTFILES" == false ]]; then
	CHOICE=true
	CUI=true
	GUI=true
	INSTALL_DOTFILES=true
fi

# OSを自動で取得し、指定されたOSと一致するか確認
# OSが指定されていない場合、取得したOSを使用するか確認
detected_os=$(get_os | to_lower)
if [[ -z "$OS" ]]; then
	if [[ -z "$detected_os" ]]; then
		log_error "OS is not specified." >&2
		usage
		exit 1
	fi

	# TODO: Yes/Noプロンプトを実装する
	echo -e "\e[33mOS is not specified. detected: \e[34m$detected_os\e[0m"
	read -r -n 1 -p "$(echo -e "Do you want to continue as \e[34m$detected_os\e[0m? [Y/n]: ")" to_continue
	echo
	if [[ ! "$to_continue" =~ ^[Yy]$ ]]; then
		echo -e "\e[31mPlease specify the OS.\e[0m" >&2
		usage
		exit 1
	fi
	OS="$detected_os"
fi
if [[ "$OS" != "$detected_os" ]]; then
	echo -e "\e[33mThe specified OS is different from the detected OS. detected: \e[34m$detected_os\e[0m"
	read -r -n 1 -p "$(echo -e "Do you want to continue as \e[34m$OS\e[0m? [Y/n]: ")" to_continue
	echo
	if [[ ! "$to_continue" =~ ^[Yy]$ ]]; then
		echo -e "\e[31mPlease specify the correct OS.\e[0m" >&2
		exit 1
	fi
fi

# スプラッシュを表示
splash
sleep 2

# 有効なサフィックスを取得
valid_suffixes=()
IFS=" " read -r -a valid_suffixes < <(get_os_hierarchy "$OS" || (log_error "The specified OS is invalid." >&2 && exit 1))

# スクリプトのフィルター
FILTER=""
if [[ "$CUI" == true && "$GUI" == true ]]; then
	FILTER="(cui|gui)"
elif [[ "$CUI" == true ]]; then
	FILTER="cui"
elif [[ "$GUI" == true ]]; then
	FILTER="gui"
fi

# スクリプトを取得
scripts=()
mapfile -t scripts < <(find_files_with_suffixes "./scripts" "sh" "${valid_suffixes[@]}" | grep -E "__${FILTER}__")

# チョイスモード
if [[ "$CHOICE" == true ]]; then
	# チョイス用の別名を作る
	tag=()
	aka=()
	for script in "${scripts[@]}"; do
		[[ "$script" =~ __cui__ ]] && tag+=("\e[1;43;30m CUI \e[0m")
		[[ "$script" =~ __gui__ ]] && tag+=("\e[1;44;30m GUI \e[0m")
		# shellcheck disable=SC2119
		aka+=("$(basename "$script" | remove_suffix | remove_extension | remove_front_number | snake2pascal)")
	done
	mapfile -t scripts < <(choose --title "Choose the installation scripts." "${scripts[@]}" --aka "${aka[@]}" --tag "${tag[@]}")
fi

# スクリプトを実行、statusが0以外の場合はエラーとして処理、STDERRがあればWarningとして表示
# 最後にまとめてRESULTを表示
# エラーがあれば最後に1を返すためにHAS_ERRORをtrueにする
RESULT=""
HAS_ERROR=false
for script in "${scripts[@]}"; do
	tempfile=$(mktemp)
	# エラーが発生したら、RESULTにエラーメッセージを追加して最後にまとめて表示
	# チョイスモードでは、--choiceオプションを追加
	if ! bash "$script" "${valid_suffixes[@]}" "$([[ "$CHOICE" == true ]] && echo "--choice")" 2> "$tempfile"; then
		RESULT+="$(log_error "$script" "SCRIPT")\n"
		RESULT+="$(echo -n "$(cat "$tempfile")" | sed 's/^/	/g')\n"
		HAS_ERROR=true
	elif [[ -n $(cat "$tempfile") ]]; then
		RESULT+="$(log_warning "$script" "SCRIPT")\n"
		RESULT+="$(echo -n "$(cat "$tempfile")" | sed 's/^/	/g')\n"
	else
		RESULT+="$(log_success "$script" "SCRIPT")\n"
	fi
	rm "$tempfile"
done
echo
echo
echo
echo -e "$RESULT"

# ドットファイルの処理
if [[ "$INSTALL_DOTFILES" == true ]]; then
	dotfiles=()
	mapfile -t dotfiles < <(find_files_or_dirs_with_suffixes "dotfiles" "*" "${valid_suffixes[@]}")
	# チョイスモード
	if [[ "$CHOICE" == true ]]; then
		# チョイス用の別名を作る
		aka=()
		for dotfile in "${dotfiles[@]}"; do
			# shellcheck disable=SC2119
			aka+=("$(echo "$dotfile" | sed 's/dotfiles\///' | remove_suffix)")
		done
		mapfile -t dotfiles < <(choose --title "Choose the dotfiles" "${dotfiles[@]}" --aka "${aka[@]}")
	fi

    for dotfile in "${dotfiles[@]}"; do
		[[ -z $dotfile ]] && continue

		# shellcheck disable=SC2119
        base_name="$(basename "$dotfile" | remove_suffix)"
		link_name=~/$base_name

		if [ -L "$link_name" ]; then
			unlink "$link_name"
			log "$link_name is already symlink, unlink..." "$(blightyellow)UNLINK" "DOTFILES"
		fi
		if [[ -e "$link_name" ]]; then
			[[ ! -d ~/.dotbackup ]] && mkdir ~/.dotbackup
			mv "$link_name" ~/.dotbackup/"$base_name.bak"
			log "$link_name is already exists, backup to ~/.dotbackup/$base_name.bak" "BACKUP" "DOTFILES"
		fi

		[[ ! -d $(dirname "$link_name") ]] && mkdir -p "$(dirname "$link_name")"
		ln -snf "$(pwd)/$dotfile" "$link_name"
		log_success "$link_name -> $(pwd)/$dotfile" "DOTFILES"
    done
fi

echo
echo -e "$(blightblue) $(bgray | flightblue) All process has been completed! $(blightblue) $(normal)"
popd >/dev/null || (echo -e "$(fred)Failed to popd$(normal)" >&2 && exit 1)
if [[ "$HAS_ERROR" == true ]]; then
	exit 1
fi
exit 0
