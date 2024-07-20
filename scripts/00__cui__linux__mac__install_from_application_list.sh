#! /bin/bash
set -euo pipefail

cd "$(dirname "$0")" || (echo -e "\e[31mFaild cd to sh dir\e[0m" >&2 && exit 1)

HAS_ERROR=false



. ../lib/utility.sh
. ../lib/ui/log.sh
. ../lib/ui/choose.sh
. ../lib/ui/prompt.sh

OS="$1"
# --choiceがあれば、使用可能なサフィックスを引数で受け取る
CHOICE=false
suffixes=()
while [[ $# -gt 0 ]]; do
	case $1 in
		--choice)
			CHOICE=true
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
	log_error "Unsupported OS. OS : $OS" "INSTALL FROM APP LIST" >&2
	exit 1
fi



lists=()
mapfile -t lists < <(find_files_with_suffixes "./lists" "list" "${suffixes[@]}")

if [[ $CHOICE == true ]]; then
	aka=()
	for list in "${lists[@]}"; do
		# shellcheck disable=SC2119
		aka+=("$(basename "$list" | remove_suffix | remove_extension | remove_front_number | snake2pascal)")
	done
	tag=()
	for list in "${lists[@]}"; do
		# shellcheck disable=SC2119
		script_os=$(basename "$list" | get_suffix | sed 's/^__\|__$//g' | to_upper)
		tag+=("$(special_color "$script_os") $script_os $(normal)")
	done
	mapfile -t lists < <(choose --title "Choose the application list" "${lists[@]}" --aka "${aka[@]}" --tag "${tag[@]}" 2>/dev/tty)
fi




declare -A each_apps=()
for list in "${lists[@]}"; do
	[[ ! -f $list ]] && continue

	apps=()
	if [[ $CHOICE == true ]]; then
		lines=()
		mapfile -t lines < <(grep -vE '^\s*$' -- "$list" | sed 's/\(#[^\-]*\)-*$/\1/')

		aka=()
		tag=()
		CURRENT_TAG=""
		for line in "${lines[@]}"; do
			if [[ $line =~ ^\s*# ]]; then
				# shellcheck disable=SC2119
				CURRENT_TAG=" $(echo "$line" | sed 's/[^#]*#\s*//' | to_upper | trim) "
				continue
			fi
			COMMENT=""
			if [[ $line =~ \# ]]; then
				# shellcheck disable=SC2001
				COMMENT=" - $(echo "$line" | sed 's/[^#]*#\s*//')"
			fi
			APP_NAME=${line//\s*#.*/}
			apps+=("$APP_NAME")
			aka+=("$APP_NAME$COMMENT")
			tag+=("$(special_color "$CURRENT_TAG")$CURRENT_TAG$(normal)")
		done

		mapfile -t apps < <(choose --title "Choose the applications" "${apps[@]}" --aka "${aka[@]}" --tag "${tag[@]}" 2>/dev/tty)
	else
		mapfile -t apps < <(grep -vE '^\s*$|^\s*#' -- "$list" | sed 's/\s*#.*//')
	fi

	each_apps["$list"]="${apps[*]}"
done

for list in "${!each_apps[@]}"; do
	log_info "Installing from $list" "INSTALL FROM APP LIST"

	# 配列が1つの引数とみなされるので、配列を展開して渡す
	apps=()
	mapfile -t apps < <(echo "${each_apps[$list]}" | tr ' ' '\n')
	if ! bash "$install_script" "${apps[@]}"; then
		HAS_ERROR=true
	fi
done



[[ $HAS_ERROR == true ]] && exit 1 || exit 0
