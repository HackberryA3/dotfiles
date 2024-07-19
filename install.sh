#!/bin/bash
set -euo pipefail 

PWD=$(pwd)
cd "$(dirname "$0")" || (echo -e "\e[31mFaild run script\e[0m" >&2 && exit 1)

# 使用可能なOSサフィックスと種類サフィックスのリスト
OS_SUFFIXES=("linux" "debian" "kali" "ubuntu" "arch" "manjaro" "mac" "win")
KALI_SUFFIXES=("debian" "linux")
UBUNTU_SUFFIXES=("debian" "linux")
DEBIAN_SUFFIXES=("linux")
MANJARO_SUFFIXES=("arch" "linux")
ARCH_SUFFIXES=("linux")

# デフォルト値
OS=""
CUI=false
GUI=false
CHOICE=false
INSTALL_DOTFILES=false

source lib/choose.sh

# Usage
# 関数: 使用方法を表示
function usage {
	echo "Usage: $0 [OPTIONS] OS" >&2
	echo "Options:" >&2
	echo "  -h, --help: Show this help message and exit" >&2
	echo "	--choice(default): Choose the installation script interactively" >&2
	echo "  --dotfiles: Install dotfiles" >&2
	echo "  --cui: Install CUI applications" >&2
	echo "  --gui: Install GUI applications" >&2
	echo "  --all: Install all applications" >&2
	echo "OS:" >&2
	echo "	linux" >&2
	echo "	├─debian" >&2
	echo "	| ├─kali" >&2
	echo "	| └─ubuntu" >&2
	echo "	└─arch" >&2
	echo "	  └─manjaro" >&2
	echo "	mac" >&2
	echo "	win" >&2
}

# 関数: スプラッシュを表示
function splash {
	echo -e "\e[32m\n" \
			" _   _            _    _                             _    _____  \n" \
			"| | | | __ _  ___| | _| |__   ___ _ __ _ __ _   _   / \  |___ /  \n" \
			"| |_| |/ _\` |/ __| |/ / '_ \ / _ \ '__| '__| | | | / _ \   |_ \  \n" \
			"|  _  | (_| | (__|   <| |_) |  __/ |  | |  | |_| |/ ___ \ ___) | \n" \
			"|_| |_|\__,_|\___|_|\_\_.__/ \___|_|  |_|   \__, /_/   \_\____/  \n" \
			"                                            |___/                \e[0m"
	echo -e "\e[35m" \
			"                    _       _    __ _ _\n" \
			"                  _| | ___ | |_ / _(_) | ___  ___\n" \
			"                / _\` |/ _ \| __| |_| | |/ _ \/ __|\n" \
			"               | (_| | (_) | |_|  _| | |  __/\__ \\n" \
			"              (_)__,_|\___/ \__|_| |_|_|\___||___/\e[0m\n"
}

# 関数: OSを自動で取得する
function get_os {
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		if [[ -f /etc/os-release ]]; then
			. /etc/os-release
			echo "$ID"
		elif [[ -f /etc/redhat-release ]]; then
			echo "redhat"
		else
			echo "linux"
		fi
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		echo "mac"
	elif [[ "$OSTYPE" == "msys" ]]; then
		echo "win"
	fi
}

# 関数: 指定したOSサフィックスに基づいて有効なサフィックスを返す
function get_valid_suffixes {
    local os="$1"
    local valid_suffixes=()
    
    for suffix in "${OS_SUFFIXES[@]}"; do
        if [[ "$suffix" == "$os" ]]; then
            valid_suffixes+=("$suffix")
			break
        fi
    done

	if [[ "${#valid_suffixes[@]}" -eq 0 ]]; then
		echo -e "\e[31mUnsupported OS: $os\e[0m" >&2
		exit 1
	fi

	case "$os" in
		"kali") valid_suffixes+=("${KALI_SUFFIXES[@]}") ;;
		"ubuntu") valid_suffixes+=("${UBUNTU_SUFFIXES[@]}") ;;
		"debian") valid_suffixes+=("${DEBIAN_SUFFIXES[@]}") ;;
		"manjaro") valid_suffixes+=("${MANJARO_SUFFIXES[@]}") ;;
		"arch") valid_suffixes+=("${ARCH_SUFFIXES[@]}") ;;
	esac

    valid_suffixes+=("all")
    echo "${valid_suffixes[@]}"
}

# 関数: 指定されたサフィックスに一致するファイルを見つける
function find_files_with_suffixes {
    local dir="$1"
	local extension="$2"
    shift 2
    local suffixes=("$@")
    local files=()

    for suffix in "${suffixes[@]}"; do
		founds=()
		mapfile -t founds < <(find "$dir" -name "*__${suffix}__*.${extension}")
		files+=("${founds[@]}")
	done

	printf '%s\n' "${files[@]}" | sort -Vu
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
            OS="$1"
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
detected_os=$(get_os)
if [[ -z "$OS" ]]; then
	if [[ -z "$detected_os" ]]; then
		echo -e "\e[31mOS is not specified.\e[0m" >&2
		usage
		exit 1
	fi

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
IFS=" " read -r -a valid_suffixes < <(get_valid_suffixes "$OS")

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
		[[ "$script" =~ __cui__ ]] && tag+=("[\e[33mCUI\e[0m]")
		[[ "$script" =~ __gui__ ]] && tag+=("[\e[34mGUI\e[0m]")
		aka+=("$(basename "$script" | sed 's/__.*__//' | sed 's/\.sh//' | sed 's/^[0-9]*//')")
	done
	mapfile -t scripts < <(choose --title "Choose the installation scripts" "${scripts[@]}" --aka "${aka[@]}" --tag "${tag[@]}")
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
	if ! bash "$script" "$([[ "$CHOICE" == true ]] && echo "--choice")" 2> "$tempfile"; then
		RESULT+="\e[1;46;30m SCRIPTS \e[1;41;30m ERROR \e[1;40;34m $script \e[0m\n"
		RESULT+="$(echo -n "$(cat "$tempfile")" | sed 's/^/	/g')\n"
		HAS_ERROR=true
	elif [[ -n $(cat "$tempfile") ]]; then
		RESULT+="\e[1;46;30m SCRIPTS \e[1;43;30m WARNING \e[1;40;34m $script \e[0m\n"
		RESULT+="$(echo -n "$(cat "$tempfile")" | sed 's/^/	/g')\n"
	else
		RESULT+="\e[1;46;30m SCRIPTS \e[1;42;30m SUCCESS \e[1;40;34m $script \e[0m\n"
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
	mapfile -t dotfiles < <(find_files_with_suffixes "dotfiles" "*" "${valid_suffixes[@]}")
	# チョイスモード
	if [[ "$CHOICE" == true ]]; then
		# チョイス用の別名を作る
		aka=()
		for dotfile in "${dotfiles[@]}"; do
			aka+=("$(basename "$dotfile" | sed 's/__.*__//')")
		done
		mapfile -t dotfiles < <(choose --title "Choose the dotfiles" "${dotfiles[@]}" --aka "${aka[@]}")
	fi

    for dotfile in "${dotfiles[@]}"; do
		if [[ -z $dotfile ]]; then
			continue
		fi
        base_name=$(basename "$dotfile" | sed 's/__.*__//')
		link_name=~/$base_name

		if [ -L "$link_name" ]; then
			unlink "$link_name"
			echo -e "\e[1;46;30m DOTFILES \e[1;43;30m UNLINK \e[1;40;34m $link_name is already symlink, unlinking... \e[0m"
		fi
		if [[ -e "$link_name" ]]; then
			if [[ ! -d ~/.dotbackup ]]; then
				mkdir ~/.dotbackup
			fi
			mv "$link_name" ~/.dotbackup/"$base_name.bak"
			echo -e "\e[1;46;30m DOTFILES \e[1;44;30m BACKUP \e[1;40;34m $link_name is already exists, backup to ~/.dotbackup/$base_name.bak \e[0m"
		fi
		ln -snf "$(pwd)/$dotfile" "$link_name"
		echo -e "\e[1;46;30m DOTFILES \e[1;42;30m SUCCESS \e[1;40;34m $link_name -> $(pwd)/$dotfile \e[0m"
    done
fi

echo
echo -e "\e[1;44m \e[1;40;34m All process has been completed! \e[1;44m \e[0m"
cd "$PWD" || exit
if [[ "$HAS_ERROR" == true ]]; then
	exit 1
fi
exit 0
