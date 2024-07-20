#!/bin/bash

pushd "$(pwd)" >/dev/null || (echo -e "\e[31mFailed pushd\e[0m" >&2 && exit 1)
cd "$(dirname "${BASH_SOURCE:-$0}")" || exit 1
. prompt.sh
popd >/dev/null || (echo -e "\e[31mFailed popd\e[0m" >&2 && exit 1)

function log {
	local msg="${1:-}" 
	[[ -n "$msg" ]] && msg=" $msg "
	local head="${2:-}"
	[[ -n "$head" ]] && head=" $head "
	local sender="${3:-}"
	[[ -n "$sender" ]] && sender=" $sender "
	echo -e "$(bcyan | fblack)$sender$(blightblue)$head$(bgray | flightblue)$msg$(normal)"
}
function log_info {
	local msg="${1:-}" 
	[[ -n "$msg" ]] && msg=" $msg "
	local sender="${2:-}"
	[[ -n "$sender" ]] && sender=" $sender "
	echo -e "$(bcyan | fblack)$sender$(blightblue) INFO $(bgray | flightblue)$msg$(normal)"
}
function log_success {
	local msg="${1:-}" 
	[[ -n "$msg" ]] && msg=" $msg "
	local sender="${2:-}"
	[[ -n "$sender" ]] && sender=" $sender "
	echo -e "$(bcyan | fblack)$sender$(blightgreen) SUCCESS $(bgray | flightgreen)$msg$(normal)"
}
function log_warning {
	local msg="${1:-}" 
	[[ -n "$msg" ]] && msg=" $msg "
	local sender="${2:-}"
	[[ -n "$sender" ]] && sender=" $sender "
	echo -e "$(bcyan | fblack)$sender$(blightyellow) WARNING $(bgray | flightyellow)$msg$(normal)"
}
function log_error {
	local msg="${1:-}" 
	[[ -n "$msg" ]] && msg=" $msg "
	local sender="${2:-}"
	[[ -n "$sender" ]] && sender=" $sender "
	echo -e "$(bcyan | fblack)$sender$(bred) ERROR $(bgray | fred)$msg$(normal)"
}
