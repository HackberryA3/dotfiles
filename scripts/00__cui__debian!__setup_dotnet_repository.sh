#!/bin/bash
set -euo pipefail

if [[ ! -r /etc/os-release ]]; then
	printf 'Cannot identify the Debian version: /etc/os-release is unavailable.\n' >&2
	exit 1
fi

. /etc/os-release
if [[ "${ID:-}" != "debian" || -z "${VERSION_ID:-}" ]]; then
	printf 'This script supports Debian only.\n' >&2
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
