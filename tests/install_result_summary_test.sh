#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)
work_dir=$(mktemp -d)
trap 'rm -rf -- "$work_dir"' EXIT

# shellcheck source=lib/utility.sh
source "$repo_root/lib/utility.sh"
detected_os=$(get_os)

assert_exit() {
	local expected_status="$1"
	shift
	local actual_status

	if "$@"; then
		actual_status=0
	else
		actual_status=$?
	fi

	if [[ "$actual_status" -ne "$expected_status" ]]; then
		printf 'expected exit status %s, got %s: %s\n' "$expected_status" "$actual_status" "$*" >&2
		exit 1
	fi
}

assert_file_contains() {
	local expected="$1"
	local file="$2"

	if ! grep -Fq -- "$expected" "$file"; then
		printf 'expected %s to contain: %s\n' "$file" "$expected" >&2
		cat "$file" >&2
		exit 1
	fi
}

create_fixture() {
	local name="$1"
	local fixture="$work_dir/$name"

	mkdir -p "$fixture/scripts" "$fixture/dotfiles" "$fixture/bin" "$fixture/home"
	cp "$repo_root/install.sh" "$fixture/install.sh"
	cp -R "$repo_root/lib" "$fixture/lib"
	printf '%s\n' '#!/usr/bin/env bash' 'exit 0' > "$fixture/bin/sleep"
	chmod +x "$fixture/bin/sleep"
	printf '%s\n' "$fixture"
}

create_success_script() {
	local fixture="$1"
	local filename="$2"

	# shellcheck disable=SC2016 # Generate a fixture script that expands MARKER_FILE later.
	printf '%s\n' \
		'#!/usr/bin/env bash' \
		'printf "%s\\n" success >> "$MARKER_FILE"' \
		> "$fixture/scripts/$filename"
}

create_failure_script() {
	local fixture="$1"
	local filename="$2"

	# shellcheck disable=SC2016 # Generate a fixture script that expands MARKER_FILE later.
	printf '%s\n' \
		'#!/usr/bin/env bash' \
		'printf "%s\\n" failure >> "$MARKER_FILE"' \
		'printf "%s\\n" "simulated failure" >&2' \
		'exit 42' \
		> "$fixture/scripts/$filename"
}

run_install() {
	local fixture="$1"
	local output_file="$2"
	local marker_file="$3"

	HOME="$fixture/home" \
	PATH="$fixture/bin:$PATH" \
	MARKER_FILE="$marker_file" \
	bash "$fixture/install.sh" --all "$detected_os" > "$output_file" 2>&1
}

success_fixture=$(create_fixture success)
success_output="$success_fixture/output"
success_marker="$success_fixture/marker"
create_success_script "$success_fixture" '10__cui__all__success.sh'

assert_exit 0 run_install "$success_fixture" "$success_output" "$success_marker"
assert_file_contains 'success' "$success_marker"
assert_file_contains '10__cui__all__success.sh' "$success_output"
assert_file_contains 'All processes completed successfully!' "$success_output"

failure_fixture=$(create_fixture failure)
failure_output="$failure_fixture/output"
failure_marker="$failure_fixture/marker"
create_failure_script "$failure_fixture" '10__cui__all__failure.sh'
create_success_script "$failure_fixture" '20__cui__all__success.sh'

assert_exit 1 run_install "$failure_fixture" "$failure_output" "$failure_marker"
assert_file_contains 'failure' "$failure_marker"
assert_file_contains 'success' "$failure_marker"
assert_file_contains '10__cui__all__failure.sh' "$failure_output"
assert_file_contains '20__cui__all__success.sh' "$failure_output"
assert_file_contains 'simulated failure' "$failure_output"
assert_file_contains 'One or more scripts failed.' "$failure_output"
