#!/bin/bash

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
	return 0
}

# 関数: OSのヒエラルキーを取得
# 引数: OS名
function get_os_hierarchy {
	local os="$1"
	# 連想配列を再帰で取得していく
	local -A os_hierarchy=(
		["linux"]="all"

		["debian"]="linux"
		["mx"]="debian"
		["antix"]="debian"
		["kali"]="debian"
		["ubuntu"]="debian"
		["linuxmint"]="ubuntu"
		["zorin"]="ubuntu"
		["pop"]="ubuntu"
		["neon"]="ubuntu"

		["arch"]="linux"
		["endeavouros"]="arch"
		["manjaro"]="arch"
		["cachyos"]="arch"

		["rhel"]="linux"
		["centos"]="rhel"
		["fedora"]="rhel"
		["nobara"]="fedora"

		["opensuse"]="linux"

		["unix"]="all"
		
		["freebsd"]="unix"

		["mac"]="all"
		["windows"]="all"
	)

	# 連想配列にキーが存在しない場合はエラー
	local ok=false
	for key in "${!os_hierarchy[@]}"; do
		if [[ "$key" == "$os" ]]; then
			ok=true
			break
		fi
	done
	[[ $ok == false ]] && return 1

	local -a hierarchy=( "$os" )
	while [[ "${hierarchy[-1]}" != "all" ]]; do
		hierarchy+=( "${os_hierarchy[${hierarchy[-1]}]}" )
	done

	echo "${hierarchy[@]}"
	return 0
}

# 関数: 指定されたサフィックスに一致するファイルを見つける
# 引数: 1.ディレクトリ, 2.拡張子, 3.サフィックスの配列
function find_files_with_suffixes {
    local dir="$1"
	local extension="$2"
    shift 2
    local suffixes=("$@")
    local files=()

    for suffix in "${suffixes[@]}"; do
		founds=()
		mapfile -t founds < <(find "$dir" -type f -name "*__${suffix}__*.${extension}")
		files+=("${founds[@]}")
	done

	printf '%s\n' "${files[@]}" | sort -Vu
}
# 関数: 指定されたサフィックスに一致するファイルかフォルダを見つける
# 引数: 1.ディレクトリ, 2.拡張子, 3.サフィックスの配列
function find_files_or_dirs_with_suffixes {
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

# 関数: __.*__形式のサフィックスを削除
function remove_suffix {
	local filename=""
	if [[ $# -ne 0 ]]; then
		filename="$1"
	elif [[ -p /dev/stdin ]]; then
		filename=$(cat -)
	fi
	echo "${filename//__*__/}"
}
# 関数: __.*__形式のサフィックスを取得
function get_suffix {
	local filename=""
	if [[ $# -ne 0 ]]; then
		filename="$1"
	elif [[ -p /dev/stdin ]]; then
		filename=$(cat -)
	fi
	# shellcheck disable=SC2001
	echo "$filename" | sed 's/.*__\(.*\)__.*/\1/'
}
# 関数: 拡張子を削除
function remove_extension {
	local filename=""
	if [[ $# -ne 0 ]]; then
		filename="$1"
	elif [[ -p /dev/stdin ]]; then
		filename=$(cat -)
	fi
	echo "${filename%.*}"
}
# 関数: 先頭の数字を削除
function remove_front_number {
	local filename=""
	if [[ $# -ne 0 ]]; then
		filename="$1"
	elif [[ -p /dev/stdin ]]; then
		filename=$(cat -)
	fi
	# shellcheck disable=SC2001
	echo "$filename" | sed 's/^[0-9]*//'
}

# 関数: スネークケースをパスカルケースに変換
function snake2pascal {
	local str=""
	if [[ $# -ne 0 ]]; then
		str="$1"
	elif [[ -p /dev/stdin ]]; then
		str=$(cat -)
	fi
	echo "$str" | sed -r 's/(\b|_)(.)/\u\2/g'
}
# 関数: すべて大文字に変換
function to_upper {
	local str=""
	if [[ $# -ne 0 ]]; then
		str="$1"
	elif [[ -p /dev/stdin ]]; then
		str=$(cat -)
	fi
	echo "$str" | tr '[:lower:]' '[:upper:]'
}
# 関数: すべて小文字に変換
function to_lower {
	local str=""
	if [[ $# -ne 0 ]]; then
		str="$1"
	elif [[ -p /dev/stdin ]]; then
		str=$(cat -)
	fi
	echo "$str" | tr '[:upper:]' '[:lower:]'
}
# 関数: 先頭と末尾の空白を削除
function trim {
	local str=""
	[[ $# -ne 0 ]] && str="$1" || [[ -p /dev/stdin ]] && str=$(cat -)
	echo "$str" | sed -e 's/^\s*//' -e 's/\s*$//'
}
