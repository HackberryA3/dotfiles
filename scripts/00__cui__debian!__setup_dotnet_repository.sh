#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")" || (echo -e "\e[31mFaild cd to sh dir\e[0m" >&2 && exit 1)
[[ ! -f ../lib/ui/log.sh ]] && echo -e "\e[31m../lib/ui/log.sh not found\e[0m" >&2 && exit 1
. ../lib/ui/log.sh

if [[ ! -r /etc/os-release ]]; then
	log_error "Cannot identify the Debian version: /etc/os-release is unavailable." "DOTNET REPOSITORY" >&2
	exit 1
fi

. /etc/os-release
if [[ "${ID:-}" != "debian" || -z "${VERSION_ID:-}" ]]; then
	log_error "This script supports Debian only." "DOTNET REPOSITORY" >&2
	exit 1
fi

run_privileged() {
	if [[ $(id -u) -eq 0 ]]; then
		"$@"
	else
		sudo "$@"
	fi
}

repository_package="$(mktemp)"
trap 'rm -f "$repository_package"' EXIT

run_privileged apt-get update
run_privileged apt-get install -y ca-certificates wget
wget --quiet --output-document "$repository_package" "https://packages.microsoft.com/config/debian/${VERSION_ID}/packages-microsoft-prod.deb"
run_privileged dpkg -i "$repository_package"
run_privileged apt-get update
