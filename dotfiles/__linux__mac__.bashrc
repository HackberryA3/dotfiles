# インタラクティブでなければ終了
case $- in
	*i*) ;;
	*) exit 0;;
esac


# 履歴設定
HISTFILE=~/.bash_history
HISTSIZE=1000
HISTFILESIZE=1000
HISTCONTROL=ignoreboth # 重複するコマンドは記録しない
shopt -s histappend # 履歴ファイルを上書きではなく追加していく
shopt -s cmdhist # 複数行のコマンドを1行にまとめる 

# 補完設定
shopt -s no_empty_cmd_completion # 入力されていない状態での補完をしない
shopt -s cdspell # cdコマンドのスペルミスを訂正する

# 便利機能
set -o notify # バックグラウンドジョブ終了時にメッセージを表示
unset MAILCHECK # メールチェックをしない（メールボックスがあるときにプロンプトに通知する機能）

# lessの設定
export PAGER=less
export LESS="-i -g -M -R -S -x4 -F -X -W"
alias lessh='LESSOPEN="| src-hilite-lesspipe.sh %s" less'
alias lessp='eval "$(lesspipe)" && less'
## manページに色を付ける
export LESS_TERMCAP_mb=$'\E[01;34m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.

# エイリアス
alias ls='ls --color=auto'
alias la='ls -FAClhg --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias tree='tree -C'
alias diff='diff --color=auto'

alias path='echo -e ${PATH//:/\\n}'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

if (command -v "ffuf" > /dev/null 2>&1); then
	alias ffuf='ffuf -c'
fi



# 追加設定の読み込み
# findコマンドの代替関数を定義
search_files() {
    local search_dir="${1:-.}"  # 検索開始ディレクトリ（デフォルトはカレントディレクトリ）
    shift  # 最初の引数（ディレクトリ）を取り除く
    local patterns=("$@")  # 残りの引数は検索パターンとして配列に格納

    # 再帰的にディレクトリを探索する内部関数
    recursive_search() {
        local dir="$1"

        # ディレクトリ内のファイルとサブディレクトリを一覧表示（隠しファイルも含む）
        for item in "$dir"/{*,.*}; do
            # 存在するファイルまたはディレクトリのみ処理
            if [ -e "$item" ]; then
                # 各パターンに一致するファイルを出力
                for pattern in "${patterns[@]}"; do
					# shellcheck disable=SC2053
                    if [[ "$(basename "$item")" == $pattern ]]; then
                        echo "$item"
                    fi
                done

                # ディレクトリであれば再帰的に探索
                if [ -d "$item" ] && [ "$item" != "$dir/." ] && [ "$item" != "$dir/.." ]; then
                    recursive_search "$item"
                fi
            fi
        done
    }

    # 探索を開始
    recursive_search "$search_dir"
}
extends=()
mapfile -t extends < <(search_files ~/.bash '*.sh' '*.bash' | sort -V)
for extend in "${extends[@]}"; do
	. "$extend"
done

unset -f search_files
