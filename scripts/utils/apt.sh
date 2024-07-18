#! /bin/bash
set -euo pipefail

LIST=$1

apps=()
mapfile -t apps < <(grep -vE '^\s*$|^\s*#' -- "$LIST" | sed 's/#.*$//')

FAIL_COUNT=0
for app in "${apps[@]}"; do
	if [[ $(id -u) -eq 0 ]]; then
		if ! apt-get install "$app" -y; then
			FAIL_COUNT=$((FAIL_COUNT + 1))
		fi
	else
		if ! sudo apt-get install "$app" -y; then
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
