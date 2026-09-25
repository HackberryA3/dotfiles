#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
# shellcheck source=lib/utility.sh
source "$REPO_ROOT/lib/utility.sh"

temp_dir=""

cleanup() {
	if [[ -n "$temp_dir" ]]; then
		rm -rf -- "$temp_dir"
	fi
}
trap cleanup EXIT

assert_equals() {
	local expected="$1"
	local actual="$2"

	if [[ "$actual" != "$expected" ]]; then
		printf 'expected: %s\nactual: %s\n' "$expected" "$actual" >&2
		return 1
	fi
}

assert_contains() {
	local expected="$1"
	shift
	local actual=""

	for actual in "$@"; do
		if [[ "$actual" == "$expected" ]]; then
			return 0
		fi
	done

	printf 'expected selected file: %s\n' "$expected" >&2
	return 1
}

assert_not_contains() {
	local unexpected="$1"
	shift
	local actual=""

	for actual in "$@"; do
		if [[ "$actual" == "$unexpected" ]]; then
			printf 'unexpected selected file: %s\n' "$unexpected" >&2
			return 1
		fi
	done
}

select_files() {
	local os="$1"
	local directory="${2:-$temp_dir}"
	local suffixes_output=""
	local -a suffixes=()

	suffixes_output="$(get_os_resource_suffixes "$os")"
	IFS=" " read -r -a suffixes <<< "$suffixes_output"
	find_files_with_suffixes "$directory" "list" "${suffixes[@]}"
}

test_resource_suffixes() {
	assert_equals "debian linux all debian!" "$(get_os_resource_suffixes debian)"
	assert_equals "ubuntu debian linux all ubuntu!" "$(get_os_resource_suffixes ubuntu)"
	assert_equals "kali debian linux all kali!" "$(get_os_resource_suffixes kali)"

	if get_os_resource_suffixes unknown >/dev/null; then
		printf 'unknown OS must not have resource suffixes\n' >&2
		return 1
	fi
}

test_exact_os_selection() {
	local -a debian_files=()
	local -a ubuntu_files=()
	local -a kali_files=()
	local shared_file=""
	local debian_only_file=""
	local ubuntu_only_file=""
	local kali_only_file=""

	temp_dir="$(mktemp -d)"
	shared_file="$temp_dir/00__debian__shared.list"
	debian_only_file="$temp_dir/00__debian!__debian-only.list"
	ubuntu_only_file="$temp_dir/00__ubuntu!__ubuntu-only.list"
	kali_only_file="$temp_dir/00__kali!__kali-only.list"
	touch "$shared_file" "$debian_only_file" "$ubuntu_only_file" "$kali_only_file"

	mapfile -t debian_files < <(select_files debian)
	assert_contains "$shared_file" "${debian_files[@]}"
	assert_contains "$debian_only_file" "${debian_files[@]}"
	assert_not_contains "$ubuntu_only_file" "${debian_files[@]}"
	assert_not_contains "$kali_only_file" "${debian_files[@]}"

	mapfile -t ubuntu_files < <(select_files ubuntu)
	assert_contains "$shared_file" "${ubuntu_files[@]}"
	assert_contains "$ubuntu_only_file" "${ubuntu_files[@]}"
	assert_not_contains "$debian_only_file" "${ubuntu_files[@]}"
	assert_not_contains "$kali_only_file" "${ubuntu_files[@]}"

	mapfile -t kali_files < <(select_files kali)
	assert_contains "$shared_file" "${kali_files[@]}"
	assert_contains "$kali_only_file" "${kali_files[@]}"
	assert_not_contains "$debian_only_file" "${kali_files[@]}"
	assert_not_contains "$ubuntu_only_file" "${kali_files[@]}"
}

test_package_list_selection() {
	local list_directory="$REPO_ROOT/scripts/lists"
	local -a debian_lists=()
	local -a ubuntu_lists=()
	local -a kali_lists=()

	mapfile -t debian_lists < <(select_files debian "$list_directory")
	assert_contains "$list_directory/__debian__pg_lang.list" "${debian_lists[@]}"
	assert_contains "$list_directory/__debian!__pg_lang.list" "${debian_lists[@]}"
	assert_contains "$list_directory/00__debian!__basic_tools.list" "${debian_lists[@]}"
	assert_not_contains "$list_directory/__ubuntu!__pg_lang.list" "${debian_lists[@]}"

	mapfile -t ubuntu_lists < <(select_files ubuntu "$list_directory")
	assert_contains "$list_directory/__debian__pg_lang.list" "${ubuntu_lists[@]}"
	assert_contains "$list_directory/__ubuntu__pg_lang.list" "${ubuntu_lists[@]}"
	assert_contains "$list_directory/__ubuntu!__pg_lang.list" "${ubuntu_lists[@]}"
	assert_contains "$list_directory/00__ubuntu!__basic_tools.list" "${ubuntu_lists[@]}"
	assert_not_contains "$list_directory/__debian!__pg_lang.list" "${ubuntu_lists[@]}"

	mapfile -t kali_lists < <(select_files kali "$list_directory")
	assert_contains "$list_directory/__debian__pg_lang.list" "${kali_lists[@]}"
	assert_contains "$list_directory/__kali__cracking_tools.list" "${kali_lists[@]}"
	assert_not_contains "$list_directory/__debian!__pg_lang.list" "${kali_lists[@]}"
	assert_not_contains "$list_directory/__ubuntu!__pg_lang.list" "${kali_lists[@]}"
	assert_not_contains "$list_directory/00__debian!__basic_tools.list" "${kali_lists[@]}"
	assert_not_contains "$list_directory/00__ubuntu!__basic_tools.list" "${kali_lists[@]}"
}

test_resource_suffixes
test_exact_os_selection
test_package_list_selection
