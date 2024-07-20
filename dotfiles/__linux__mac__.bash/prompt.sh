#!/bin/bash

if (which "oh-my-posh" > /dev/null 2>&1); then
	eval "$(oh-my-posh init bash --config https://gist.githubusercontent.com/HackberryA3/23c7b1c51d868de235eb8d39ea556ba9/raw/ReactiveMonokai.omp.yaml)"
else
	PS1="-[\[$(tput sgr0)\]\[\033[38;5;10m\]\d\[$(tput sgr0)\]-\[$(tput sgr0)\]\[\033[38;5;10m\]\t\[$(tput sgr0)\]]-[\[$(tput sgr0)\]\[\033[38;5;214m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;196m\]\h\[$(tput sgr0)\]]-\n-[\[$(tput sgr0)\]\[\033[38;5;33m\]\w\[$(tput sgr0)\]]\\$ \[$(tput sgr0)\]"
fi
