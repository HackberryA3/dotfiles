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

if [[ ! -n $TMUX ]]; then
	ID="`tmux list-sessions`"
	if [[ -z "$ID" ]]; then
    	tmux new-session
	elif [[ -z "$PERCOL" ]]; then
		tmux attach-session
	else
		create_new_session="Create New Session"
		ID="$ID\n${create_new_session}:"
		ID="`echo $ID | $PERCOL | cut -d: -f1`"
		if [[ "$ID" = "${create_new_session}" ]]; then
    		tmux new-session
		fi
		tmux attach-session -t "$ID"
	fi
fi
