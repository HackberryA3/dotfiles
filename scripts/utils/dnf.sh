#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")" || (echo -e "\e[31mFaild cd to sh dir\e[0m" >&2 && exit 1)
[[ ! -f ../../lib/ui/log.sh ]] && echo -e "\e[31m../../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../../lib/ui/log.sh

apps=()
while [[ $# -gt 0 ]]; do
	apps+=("$1")
	shift
done

if [[ ${#apps[@]} -eq 0 ]]; then
	exit 0
fi

FAIL_COUNT=0
for app in "${apps[@]}"; do
	log_info "Installing $app..." "DNF"
	
	if command -v "dnf" > /dev/null 2>&1; then
		if [[ $(id -u) -eq 0 ]]; then
			err=$(mktemp)
			if ! dnf -q install "$app" -y > "$err" 2>&1; then
				FAIL_COUNT=$((FAIL_COUNT + 1))
				cat "$err" >&2
			fi
			rm "$err"
		else
			err=$(sudo mktemp)
			if ! sudo dnf -q install "$app" -y 2>&1 | sudo tee "$err" > /dev/null; then
				FAIL_COUNT=$((FAIL_COUNT + 1))
				sudo cat "$err" >&2
			fi
			sudo rm "$err"
		fi
	else
		if [[ $(id -u) -eq 0 ]]; then
			err=$(mktemp)
			if ! microdnf -q install "$app" -y > "$err" 2>&1; then
				FAIL_COUNT=$((FAIL_COUNT + 1))
				cat "$err" >&2
			fi
			rm "$err"
		else
			err=$(sudo mktemp)
			if ! sudo microdnf -q install "$app" -y 2>&1 | sudo tee "$err" > /dev/null; then
				FAIL_COUNT=$((FAIL_COUNT + 1))
				sudo cat "$err" >&2
			fi
			sudo rm "$err"
		fi
	fi
done



# すべて失敗していたらエラー
if [[ $FAIL_COUNT -eq ${#apps[@]} ]]; then
	exit 1
else
	exit 0
fi
