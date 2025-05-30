#!/bin/bash

# ローカルのbinディレクトリをPATHに追加する
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"
# shellcheck disable=SC1091
[[ -f "$HOME/.asdf/asdf.sh" ]] && . "$HOME/.asdf/asdf.sh"
# shellcheck disable=SC1091
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

if [[ "$(uname)" = "Darwin" ]]; then
# Java
	if BREW_OPENJDK="$(brew --prefix openjdk)"; then
		export JAVA_HOME=$BREW_OPENJDK/libexec/openjdk.jdk/Contents/Home
	fi

# LLVM
	if BREW_LLVM="$(brew --prefix llvm)"; then
		export PATH=$BREW_LLVM/bin:$PATH
		export LDFLAGS="-L$BREW_LLVM/lib"
		export CPPFLAGS="-I$BREW_LLVM/include"
	fi

# C#
	if BREW_DOTNET="$(brew --prefix dotnet)"; then
		export DOTNET_ROOT=$BREW_DOTNET/libexec
	fi
fi
