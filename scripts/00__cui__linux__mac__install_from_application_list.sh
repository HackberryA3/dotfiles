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

trim_app_name() {
	local app_name="${1%%#*}"

	app_name="${app_name#"${app_name%%[![:space:]]*}"}"
	app_name="${app_name%"${app_name##*[![:space:]]}"}"
	printf '%s\n' "$app_name"
}

install_script=""
case $OS in
	debian | ubuntu | kali)
		install_script="utils/apt.sh"
		;;
	arch | manjaro)
		install_script="utils/pacman.sh"
		;;
	rhel | centos | almalinux | fedora | nobara)
		install_script="utils/dnf.sh"
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

# 接尾辞を除いた論理名ごとに list をまとめる。
# 例: __debian__pg_lang.list と __debian!__pg_lang.list は同じ pg_lang として扱う。
logical_lists=()
declare -A list_files_by_name=()
for list in "${lists[@]}"; do
	[[ ! -f $list ]] && continue
	# shellcheck disable=SC2119
	logical_name="$(basename "$list" | remove_suffix | remove_extension | remove_front_number)"
	if [[ -z ${list_files_by_name[$logical_name]+x} ]]; then
		logical_lists+=("$logical_name")
		list_files_by_name["$logical_name"]=""
	fi
	list_files_by_name["$logical_name"]+="$list"$'\n'
done

if [[ $CHOICE == true ]]; then
	aka=()
	for logical_name in "${logical_lists[@]}"; do
		# shellcheck disable=SC2119
		aka+=("$(echo "$logical_name" | snake2pascal)")
	done
	tag=()
	display_os="$(to_upper "$OS")"
	for logical_name in "${logical_lists[@]}"; do
		tag+=("$(special_color "$OS") $display_os $(normal)")
	done
	mapfile -t logical_lists < <(choose --title "Choose the application list" "${logical_lists[@]}" --aka "${aka[@]}" --tag "${tag[@]}" 2>/dev/tty)
fi




for logical_name in "${logical_lists[@]}"; do
	apps=()
	declare -A selected_apps=()
	aka=()
	tag=()
	while IFS= read -r list; do
		[[ -z "$list" || ! -f $list ]] && continue

	if [[ $CHOICE == true ]]; then
		lines=()
		mapfile -t lines < <(grep -vE '^\s*$' -- "$list" | sed 's/\(#[^\-]*\)-*$/\1/')

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
			APP_NAME="$(trim_app_name "$line")"
			[[ -z "$APP_NAME" || -n ${selected_apps[$APP_NAME]+x} ]] && continue
			selected_apps["$APP_NAME"]=true
			apps+=("$APP_NAME")
			aka+=("$APP_NAME$COMMENT")
			tag+=("$(special_color "$CURRENT_TAG")$CURRENT_TAG$(normal)")
		done
	else
		lines=()
		mapfile -t lines < <(grep -vE '^\s*$|^\s*#' -- "$list")
		for line in "${lines[@]}"; do
			APP_NAME="$(trim_app_name "$line")"
			[[ -z "$APP_NAME" || -n ${selected_apps[$APP_NAME]+x} ]] && continue
			selected_apps["$APP_NAME"]=true
			apps+=("$APP_NAME")
		done
	fi
	done <<< "${list_files_by_name[$logical_name]}"

	if [[ $CHOICE == true ]]; then
		mapfile -t apps < <(choose --title "Choose the applications" "${apps[@]}" --aka "${aka[@]}" --tag "${tag[@]}" 2>/dev/tty)
	fi

	[[ ${#apps[@]} -eq 0 ]] && continue
	# shellcheck disable=SC2119
	logical_name_display="$(echo "$logical_name" | snake2pascal)"
	log_info "Installing from $logical_name_display" "INSTALL FROM APP LIST"

	if ! bash "$install_script" "${apps[@]}"; then
		HAS_ERROR=true
	fi
done



[[ $HAS_ERROR == true ]] && exit 1 || exit 0
