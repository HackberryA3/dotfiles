#!/bin/bash

if (! which "tmux" > /dev/null 2>&1); then
	return 0
fi

if [[ ! -e ~/.tmux/plugins/tpm ]]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if (which fzf > /dev/null 2>&1); then
  	PERCOL="fzf"
fi
if (which percol > /dev/null 2>&1); then
  	PERCOL="percol"
fi
if (which peco > /dev/null 2>&1); then
  	PERCOL="peco"
fi

if [[ -z $TMUX ]]; then
	IFS=$'\n' ID="$(tmux list-sessions)"
	unset IFS
	if [[ -z "$ID" ]]; then
    	tmux -u new-session
	elif [[ -z "${PERCOL-}" ]]; then
		tmux -u attach-session
	else
		create_new_session="Create New Session"
		ID="$ID\n${create_new_session}:"
		ID="$(echo -e "$ID" | $PERCOL | cut -d: -f1)"
		if [[ "$ID" = "${create_new_session}" ]]; then
    		tmux -u new-session
		fi
		tmux -u attach-session -t "$ID"
	fi


	echo "Do you want to exit? [y/n]"
	read -n 1 -s -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		exit
	fi
fi
