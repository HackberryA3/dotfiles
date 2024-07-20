#!/bin/bash

function cursor_up {
	local -i n=1
	[[ $# -gt 0 ]] && n=$1
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[${n}A"
}
function cursor_down {
	local -i n=1
	[[ $# -gt 0 ]] && n=$1
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[${n}B"
}
function cursor_right {
	local -i n=1
	[[ $# -gt 0 ]] && n=$1
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[${n}C"
}
function cursor_left {
	local -i n=1
	[[ $# -gt 0 ]] && n=$1
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[${n}D"
}

function cursor_begin {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\r"
}
function cursor_up_begin {
	local -i n=1
	[[ $# -gt 0 ]] && n=$1
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[${n}F"
}
function cursor_down_begin {
	local -i n=1
	[[ $# -gt 0 ]] && n=$1
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[${n}E"
}

function cursor_to {
	local -i x=1
	local -i y=1
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	[[ $# -gt 0 ]] && x=$1
	[[ $# -gt 1 ]] && y=$2 && echo -en "${pipe}\033[${y};${x}H" || echo -en "${pipe}\033[${x}G"
}

function scroll_up {
	local -i n=1
	[[ $# -gt 0 ]] && n=$1
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[${n}T"
}
function scroll_down {
	local -i n=1
	[[ $# -gt 0 ]] && n=$1
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[${n}S"
}

function cursor_save {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[s"
}
function cursor_restore {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[u"
}

function clear_all {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[2J"
}
function clear_after {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[J"
}
function clear_before {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1J"
}
function clear_line {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[2K"
}
function clear_line_after {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[K"
}
function clear_line_before {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1K"
}
