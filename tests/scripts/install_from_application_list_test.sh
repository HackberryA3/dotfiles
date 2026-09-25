#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/../.." && pwd)
installer="$repo_root/scripts/00__cui__linux__mac__install_from_application_list.sh"
mock_bash_log=$(mktemp)
trap 'rm -f "$mock_bash_log"' EXIT

bash() {
	printf '%s\n' "$*" >> "$MOCK_BASH_LOG"
}

export MOCK_BASH_LOG="$mock_bash_log"
export -f bash

assert_equals() {
	local expected="$1"
	local actual="$2"

	if [[ "$actual" != "$expected" ]]; then
		printf 'expected: %s\nactual: %s\n' "$expected" "$actual" >&2
		exit 1
	fi
}

assert_output_contains() {
	local expected="$1"

	if ! grep -Fq -- "$expected" "$mock_bash_log"; then
		printf 'expected mocked installer call to contain: %s\n' "$expected" >&2
		cat "$mock_bash_log" >&2
		exit 1
	fi
}

command bash "$installer" debian 'debian!' debian linux all >/dev/null

assert_equals "2" "$(wc -l < "$mock_bash_log" | tr -d ' ')"
assert_output_contains "utils/apt.sh"
assert_output_contains "dotnet-sdk-10.0"
assert_output_contains "gcc"
assert_output_contains "gh"
