#!/bin/bash

# ローカルのbinディレクトリをPATHに追加する
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.asdf/bin" ]] && PATH="$HOME/.asdf/bin:$PATH"
[[ -d "$HOME/.asdf/shims" ]] && PATH="$HOME/.asdf/shims:$PATH"

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
