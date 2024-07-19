#! /bin/bash
set -euo pipefail

PWD=$(pwd)
cd "$(dirname "$0")" || (echo -e "\e[31mFaild run script\e[0m" >&2 && exit 1)

HAS_ERROR=false



OS="$1"
# --choiceがあれば、使用可能なサフィックスを引数で受け取る
CHOICE=false
suffixes=()
while [[ $# -gt 0 ]]; do
	case $1 in
		--choice)
			CHOICE=true
			source ../lib/choose.sh
			;;
		*)
			suffixes+=("$1")
			;;
	esac
	shift
done

install_script=""
case $OS in
	debian | ubuntu | kali)
		install_script="utils/apt.sh"
		;;
	arch | manjaro)
		install_script="utils/pacman.sh"
		;;
	mac)
		install_script="utils/brew.sh"
		;;
esac
if [[ -z $install_script ]]; then
	echo -e "\e[31mUnsupported OS. OS : $OS\e[0m" >&2
	exit 1
fi



lists=()
for suffix in "${suffixes[@]}"; do
	founds=()
	mapfile -t founds < <(find "lists" -type f -name "*__${suffix}__*.list")
	lists+=("${founds[@]}")
done
mapfile -t lists < <(echo "${lists[@]}" | tr ' ' '\n' | sort -Vu)


if [[ $CHOICE == true ]]; then
	aka=()
	for list in "${lists[@]}"; do
		aka+=("$(basename "$list" | sed 's/__.*__//' | sed 's/\.list.*//' | sed 's/^[0-9]*//' | sed -r 's/(\b|_)(.)/\u\2/g')")
	done
	tag=()
	for list in "${lists[@]}"; do
		tag+=("\e[1;44;30m $(basename "$list" | sed 's/.*\(__.*__\).*/\1/' | sed 's/^__\|__$//g' | tr '__' ', ' | sed 's/\(.*\)/\U\1/') \e[0m")
	done
	mapfile -t lists < <(choose --title "Choose the application list" "${lists[@]}" --aka "${aka[@]}" --tag "${tag[@]}" 2>/dev/tty)
fi



for list in "${lists[@]}"; do
	[[ ! -f $list ]] && continue

	apps=()
	if [[ $CHOICE == true ]]; then
		aka=()
		tag=()
		CURRENT_TAG=" "
		while read -r line; do
			if [[ $line =~ ^\s*# ]]; then
				CURRENT_TAG=$(echo "$line" | sed 's/[^#]*#\s*//' | sed 's/\(.*\)/\U\1/')
				continue
			fi
			COMMENT=""
			if [[ $line =~ \# ]]; then
				COMMENT=" - $(echo "$line" | sed 's/[^#]*#\s*//')"
			fi
			APP_NAME=${line//\s*#.*/}
			apps+=("$APP_NAME")
			aka+=("$APP_NAME$COMMENT")
			tag+=("\e[1;44;30m $CURRENT_TAG \e[0m")
		done < <(grep -vE '^\s*$' -- "$list" | sed 's/\(#[^\-]*\)-*$/\1/')

		mapfile -t apps < <(choose --title "Choose the applications" "${apps[@]}" --aka "${aka[@]}" --tag "${tag[@]}" 2>/dev/tty)
	else
		mapfile -t apps < <(grep -vE '^\s*$|^\s*#' -- "$list" | sed 's/\s*#.*//')
	fi
	echo -e "\e[1;44;30m INFO \e[1;40;34m Installing from $list \e[0m"

	if ! bash "$install_script" "${apps[@]}"; then
		HAS_ERROR=true
	fi
done

cd "$PWD" || (echo -e "\e[31mFaild run script\e[0m" >&2 && exit 1)
if [[ $HAS_ERROR == true ]]; then
	exit 1
else
	exit 0
fi
