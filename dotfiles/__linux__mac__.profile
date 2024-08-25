# ローカルのbinディレクトリをPATHに追加する
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"

if [[ "$(uname)" = "Darwin" ]]; then
# Java
	BREW_OPENJDK="$(brew --prefix openjdk)"
	if [[ $? -eq  0 ]]; then
		export JAVA_HOME=$BREW_OPENJDK/libexec/openjdk.jdk/Contents/Home
	fi

# LLVM
	BREW_LLVM="$(brew --prefix llvm)"
	if [[ $? -eq  0 ]]; then
		export PATH=$BREW_LLVM/bin:$PATH
		export LDFLAGS="-L$BREW_LLVM/lib"
		export CPPFLAGS="-I$BREW_LLVM/include"
	fi

# C#
	BREW_DOTNET="$(brew --prefix dotnet)"
	if [[ $? -eq  0 ]]; then
		export DOTNET_ROOT=$BREW_DOTNET/libexec
	fi
fi
