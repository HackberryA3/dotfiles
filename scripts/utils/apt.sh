#! /bin/bash
set -euo pipefail

LIST=$1

apps=()
mapfile -t apps < <(grep -vE '^\s*$|^\s*#' -- "$LIST" | sed 's/#.*$//')

for app in "${apps[@]}"; do
	if [[ $(id -u) -eq 0 ]]; then
		apt-get install "$app" -y
	else
		sudo apt-get install "$app" -y
	fi
done
