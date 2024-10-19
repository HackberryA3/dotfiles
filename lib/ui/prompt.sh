#!/bin/bash

function color256 {
	for i in {0..15}; do 
	  	for j in {0..15}; do  
			((c = i * 16 + j)) 
			printf "\e[48;5;%dm %02X \e[0m" $c $c  
	  	done
		echo ""
	done
}
function colorRGB {
	rgb_curve(){
		x=$1
		((x %= 192))
		if (($1 < 0)); then
			((x += 192))
		fi

		if ((x <= 0)); then
			return 0
		elif ((x < 32)); then
			return $(((x << 3) - 1))
		elif ((x < 96)); then
			return $(((16 << 4) - 1))
		elif ((x < 128)); then
			return $((((128 - x) << 3) - 1))
		elif ((x < 192)); then
			return 0
		fi
	}

	for i in {1..32}; do
		for j in {-32..160}; do
			rgb_curve $((j - 64)); r=$?
			rgb_curve j; g=$?
			rgb_curve $((j + 64)); b=$?
			printf "\e[48;2;%d;%d;%dm \e[0m" $r $g $b
		done
		echo ""
	done

	echo -e "\e[0m"
}

function normal {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[0m"
}

function bold {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1m"
}
function disable {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[2m"
}
function italic {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[3m"
}
function underline {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[4m"
}
function blink {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[5m"
}
function blink_fast {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[6m"
}
function reverse {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[7m"
}
function hide {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[8m"
}
function strike {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[9m"
}

function fblack {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[30m"
}
function fred {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[31m"
}
function fgreen {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[32m"
}
function fyellow {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[33m"
}
function fblue {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[34m"
}
function fmagenta {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[35m"
}
function fcyan {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[36m"
}
function flightgray {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[37m"
}
function fgray {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;30m"
}
function flightred {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;31m"
}
function flightgreen {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;32m"
}
function flightyellow {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;33m"
}
function flightblue {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;34m"
}
function flightmagenta {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;35m"
}
function flightcyan {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;36m"
}
function fwhite {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;37m"
}

function bblack {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[40m"
}
function bred {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[41m"
}
function bgreen {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[42m"
}
function byellow {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[43m"
}
function bblue {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[44m"
}
function bmagenta {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[45m"
}
function bcyan {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[46m"
}
function blightgray {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[47m"
}
function bgray {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;40m"
}
function blightred {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;41m"
}
function blightgreen {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;42m"
}
function blightyellow {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;43m"
}
function blightblue {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;44m"
}
function blightmagenta {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;45m"
}
function blightcyan {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;46m"
}
function bwhite {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	echo -en "${pipe}\033[1;47m"
}

function fcolor {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	local color="$1"
	echo -en "${pipe}\033[38;5;${color}m"
}
function bcolor {
	local pipe=""
	[[ -p /dev/stdin ]] && pipe=$(cat -)
	local color="$1"
	echo -en "${pipe}\033[48;5;${color}m"
}



function read_key {
	local INPUT
    IFS= read -r -n1 -s INPUT
    if [[ $INPUT == $'\x1b' ]]; then
        read -r -n2 -s INPUT
    else
        case "$INPUT" in
            "")
                echo "CR"
                ;;
            $'\x7f')
                echo "BS"
                ;;
            $'\x20')
                echo "Space"
                ;;
            *)
                echo "$INPUT"
                ;;
        esac
        return 0
    fi

    case "$INPUT" in
        '[A') #up arrow
            echo "Up"
            ;;
        '[B') #down arrow
            echo "Down"
            ;;
        '[C') #right arrow
            echo "Right"
            ;;
        '[D') #left arrow
            echo "Left"
            ;;
    esac
}



# ソフトウェアの色を取得
# 引数: 1.ソフトウェア名
function special_color {
	local name="$1"
	name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed -e 's/^\s*//' -e 's/\s*$//')
	local default="${2:-$(blightblue | fblack)}"
	[[ -z "$name" ]] && return 1
	[[ -p /dev/stdin ]] && echo -en "$(cat -)"

	case "$name" in
		# OS
		'windows' | 'win')
			echo -en "\e[48;2;0;127;206m\e[38;2;255;255;255m"
			;;
		'mac' | 'macos' | 'ios' | 'osx' | 'darwin')
			echo -en "\e[48;2;255;255;255m\e[38;2;159;159;159m"
			;;
		'linux')
			echo -en "\e[48;2;240;181;68m\e[38;2;11;11;11m"
			;;
		'debian')
			echo -en "\e[48;2;216;0;82m\e[38;2;255;255;255m"
			;;
		'ubuntu')
			echo -en "\e[48;2;226;68;48m\e[38;2;255;255;255m"
			;;
		'mint' | 'linuxmint')
			echo -en "\e[48;2;114;180;85m\e[38;2;255;255;255m"
			;;
		'zorin')
			echo -en "\e[48;2;8;175;235m\e[38;2;255;255;255m"
			;;
		'pop!_os' | 'pop')
			echo -en "\e[48;2;70;189;199m\e[38;2;255;255;255m"
			;;
		'kde neon' | 'neon')
			echo -en "\e[48;2;21;164;169m\e[38;2;255;255;255m"
			;;
		'kali')
			echo -en "\e[48;2;0;130;247m\e[38;2;255;255;255m"
			;;
		'mx' | 'mx linux')
			echo -en "\e[48;2;0;0;0m\e[38;2;255;255;255m"
			;;
		'antix')
			echo -en "\e[48;2;172;174;179m\e[38;2;255;255;255m"
			;;
		'arch')
			echo -en "\e[48;2;0;147;198m\e[38;2;255;255;255m"
			;;
		'endeavouros' | 'endeavour')
			echo -en "\e[48;2;120;71;179m\e[38;2;247;118;126m"
			;;
		'manjaro')
			echo -en "\e[48;2;15;163;138m\e[38;2;26;32;35m"
			;;
		'cachyos' | 'cachy')
			echo -en "\e[48;2;14;24;41m\e[38;2;0;208;250m"
			;;
		'rhel' | 'red hat' | 'redhat')
			echo -en "\e[48;2;242;8;36m\e[38;2;255;255;255m"
			;;
		'centos')
			echo -en "\e[48;2;240;244;248m\e[38;2;169;43;140m"
			;;
		'almalinux')
			echo -en "\e[38;2;255;255;255m\e[48;2;8;48;96m"
			;;
		'fedora')
			echo -en "\e[48;2;44;75;116m\e[38;2;255;255;255m"
			;;
		'nobara')
			echo -en "\e[48;2;91;54;127m\e[38;2;255;255;255m"
			;;
		'opensuse')
			echo -en "\e[48;2;121;186;71m\e[38;2;255;255;255m"
			;;
		'freebsd')
			echo -en "\e[48;2;255;8;39m\e[38;2;255;255;255m"
			;;
		


		# シェル
		'sh')
			echo -en "\e[48;2;0;0;0m\e[38;2;255;255;255m"
			;;
		'bash')
			echo -en "\e[48;2;42;50;55m\e[38;2;78;167;60m"
			;;
		'zsh')
			echo -en "\e[48;2;255;255;255m\e[38;2;244;81;53m"
			;;
		'fish')
			echo -en "\e[48;2;62;62;62m\e[38;2;65;157;195m"
			;;



		# プログラミング言語
		'c' | 'c++' | 'cpp' | 'c/c++' | 'c/cpp')
			echo -en "\e[48;2;0;93;151m\e[38;2;255;255;255m"
			;;
		'c#' | 'cs' | 'csharp')
			echo -en "\e[48;2;51;28;139m\e[38;2;255;255;255m"
			;;
		'java')
			echo -en "\e[48;2;9;106;120m\e[38;2;225;126;60m"
			;;
		'python' | 'py' | 'python3' | 'python2')
			echo -en "\e[48;2;8;128;186m\e[38;2;255;190;71m"
			;;
		# TODO: 他の言語も追加する
		


		*)
			echo -en "$default"
			;;
	esac
}
