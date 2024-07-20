#!/bin/bash
set -euo pipefail

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
	echo -e "\e[1;44;30m INFO \e[1;40;34m Installing $app \e[0m"
	if [[ $(id -u) -eq 0 ]]; then
		if ! apt-get -qq install "$app" -y; then
			FAIL_COUNT=$((FAIL_COUNT + 1))
		fi
	else
		if ! sudo apt-get -qq install "$app" -y; then
			FAIL_COUNT=$((FAIL_COUNT + 1))
		fi
	fi
done



# すべて失敗していたらエラー
if [[ $FAIL_COUNT -eq ${#apps[@]} ]]; then
	exit 1
else
	exit 0
fi
