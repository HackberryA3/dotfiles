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

failed_apps=()
for app in "${apps[@]}"; do
	log_info "Installing $app..." "APT"
	
	if [[ $(id -u) -eq 0 ]]; then
		err=$(mktemp)
		if ! apt-get -qq install "$app" -y > "$err" 2>&1; then
			failed_apps+=("$app")
			cat "$err" >&2
		fi
		rm "$err"
	else
		err=$(sudo mktemp)
		if ! sudo apt-get -qq install "$app" -y 2>&1 | sudo tee "$err" > /dev/null; then
			failed_apps+=("$app")
			sudo cat "$err" >&2
		fi
		sudo rm "$err"
	fi
done

if [[ ${#failed_apps[@]} -gt 0 ]]; then
	printf 'APT failed to install: %s\n' "${failed_apps[*]}" >&2
	exit 1
fi

exit 0
