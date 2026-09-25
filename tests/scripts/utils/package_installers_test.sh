#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/../../.." && pwd)
output_file=$(mktemp)
trap 'rm -f "$output_file"' EXIT

id() {
	if [[ ${1-} == "-u" ]]; then
		printf '0\n'
		return 0
	fi
	command id "$@"
}

contains_failing_package() {
	local package
	for package in "$@"; do
		if [[ $package == "failing-package" ]]; then
			return 0
		fi
	done
	return 1
}

apt-get() {
	if contains_failing_package "$@"; then
		printf 'simulated APT failure\n' >&2
		return 1
	fi
	return 0
}

dnf() {
	if contains_failing_package "$@"; then
		printf 'simulated DNF failure\n' >&2
		return 1
	fi
	return 0
}

export -f id contains_failing_package apt-get dnf

assert_exit() {
	local expected=$1
	shift
	local actual

	if "$@" > "$output_file" 2>&1; then
		actual=0
	else
		actual=$?
	fi

	if [[ $actual -ne $expected ]]; then
		printf 'expected exit status %s, got %s: %s\n' "$expected" "$actual" "$*" >&2
		cat "$output_file" >&2
		exit 1
	fi
}

assert_output_contains() {
	local expected=$1
	if ! grep -Fq -- "$expected" "$output_file"; then
		printf 'expected output to contain: %s\n' "$expected" >&2
		cat "$output_file" >&2
		exit 1
	fi
}

assert_exit 0 bash "$repo_root/scripts/utils/apt.sh" working-a working-b
assert_exit 1 bash "$repo_root/scripts/utils/apt.sh" working-a failing-package
assert_output_contains 'Failed to install: failing-package'

assert_exit 0 bash "$repo_root/scripts/utils/dnf.sh" working-a working-b
assert_exit 1 bash "$repo_root/scripts/utils/dnf.sh" working-a failing-package
assert_output_contains 'Failed to install: failing-package'
