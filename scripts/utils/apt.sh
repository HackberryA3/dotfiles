#! /bin/bash
set -euo pipefail

LIST=$1

apps=()
mapfile -t apps < <(grep -vE '^\s*$|^\s*#' -- "$LIST" | sed 's/#.*$//')

FAIL_COUNT=0
for app in "${apps[@]}"; do
	if [[ $(id -u) -eq 0 ]]; then
		apt-get install "$app" -y
	else
		sudo apt-get install "$app" -y
	fi

	if [ $? -ne 0 ]; then
		FAIL_COUNT=$((FAIL_COUNT + 1))
	fi
done



# すべて失敗していたらエラー
if [[ $FAIL_COUNT -eq ${#apps[@]} ]]; then
	exit 1
else
	exit 0
fi
