#!/bin/bash

pushd "$(pwd)" >/dev/null || (echo -e "\e[31mFailed pushd\e[0m" >&2 && exit 1)
cd "$(dirname "${BASH_SOURCE:-$0}")" || exit 1
. cursor.sh
. prompt.sh
. log.sh
popd >/dev/null || (echo -e "\e[31mFailed popd\e[0m" >&2 && exit 1)

# choose 関数の定義
choose() {
	local title="Choose"
    local limit=999
	local min=0
	local -a options=()
	local -a aka=()
	local -a tags=()
	local -a selected=()
    local -i cursor=0
    local -i selected_count=0

	local HAS_ARGS=false
    # 引数処理
	while [[ $# -gt 0 ]]; do
        case "$1" in
			--title)
				shift
				title="$1"
				;;
            --limit)
                shift
                limit="$1"
                ;;
			--min)
				shift
				min="$1"
				;;
			--aka)
				if [[ $HAS_ARGS = false ]]; then
					log_error "aka must be after args." "choose" >&2
					return 1
				fi
				for (( i = 0; i < ${#options[@]}; i++ )); do
					shift
					if [[ -z "$1" ]]; then
						log_error "The number of aka must be the same as the number of options." "choose" >&2
						return 1
					fi
					aka[i]="$1"
				done
				;;
			--tag)
				if [[ $HAS_ARGS = false ]]; then
					log_error "tag must be after args." "choose" >&2
					return 1
				fi
				for (( i = 0; i < ${#options[@]}; i++ )); do
					shift
					if [[ -z "$1" ]]; then
						log_error "The number of tag must be the same as the number of options." "choose" >&2
						return 1
					fi
					tags[i]="$1"
				done
				;;
			*)
				options+=("$1")
				HAS_ARGS=true
				;;
        esac
        shift
    done

	# 引数がない場合はパイプを見て、あればエラーを出力して終了
	if [[ $HAS_ARGS = false ]]; then
		if [[ -p /dev/stdin ]]; then
			log_error "choose is not supported with pipe." "choose" >&2
			return 1
		fi
	fi

	# 選択肢がない場合は何もしない
	if [[ ${#options[@]} -eq 0 ]]; then
		return 0
	fi
	# min が limit より大きい場合はエラーを出力して終了
	# min が 0 未満の場合はエラーを出力して終了
	# limit が 0 未満の場合はエラーを出力して終了
	if [[ $min -gt $limit ]]; then
		log_error "min must be less than or equal to limit." "choose" >&2
		return 1
	fi
	if [[ $min -lt 0 ]]; then
		log_error "min must be greater than or equal to 0." "choose" >&2
		return 1
	fi
	if [[ $limit -lt 0 ]]; then
		log_error "limit must be greater than or equal to 0." "choose" >&2
		return 1
	fi
	# akaがなければ、akaを選択肢と同じにする
	if [[ ${#aka[@]} -eq 0 ]]; then
		aka=("${options[@]}")
	fi
	# akaが指定されている場合、選択肢の数と一致するか確認
	if [[ ${#aka[@]} -ne ${#options[@]} ]]; then
		log_error "The number of aka must be the same as the number of options." "choose" >&2
		echo -e "$(fred)	aka: ${#aka[@]}, options: ${#options[@]}.$(normal)" >&2
		echo -e "$(fred)	aka: ${aka[*]}.$(normal)" >&2
		echo -e "$(fred)	options: ${options[*]}.$(normal)" >&2
		return 1
	fi
	# tagを空文字で埋める
	for (( i = 0; i < ${#options[@]}; i++ )); do
		if [[ ${#tags[@]} -le $i || -z "${tags[i]}" ]]; then
			tags[i]=""
		fi
	done

	local help_text="↑/k: Up, ↓/j: Down, Space: Select, a: SelectAll, Enter: Confirm, q: Quit"
	local -i rendered_rows=0
	local -i terminal_columns=80
	local -i title_width=0
	local -i title_rows=1
	local -i status_rows=1
	local -a option_widths=()
	local -a option_rows=()

	# ANSI SGR エスケープを除いた端末上の表示幅を返す。
	# wc -L はロケールに従って全角文字を2列として数える。
	visible_width() {
		local text="$1"
		local width

		while [[ "$text" =~ $'\033'\[[0-9\;]*m ]]; do
			text="${text/"${BASH_REMATCH[0]}"/}"
		done
		width=$(printf '%s\n' "$text" | wc -L 2> /dev/null)
		printf '%d' "$width" 2> /dev/null || printf '%d' "${#text}"
	}

	rows_for_width() {
		local -i width="$1"

		if (( width <= 0 )); then
			echo 1
		else
			echo $(( (width + terminal_columns - 1) / terminal_columns ))
		fi
	}

	tag_text() {
		local -i index="$1"
		local tag

		# タグは呼び出し側で "\e[...m" の形式で渡されるため、描画前に展開する。
		printf -v tag '%b' "${tags[index]}"
		printf '%s' "$tag"
	}

	option_text() {
		local -i index="$1"

		printf '▶ %s %s ' "$(tag_text "$index")" "${aka[index]}"
	}

	status_text() {
		local text="$selected_count "

		if [[ $limit -lt 999 ]]; then
			text+="/ $limit "
		fi
		text+="Selected"
		if [[ $selected_count -lt $min ]]; then
			text+=", $((min - selected_count)) more."
		fi
		printf '%s' "$text"
	}

	update_layout() {
		local columns
		local -i index

		columns=$(tput cols 2> /dev/null)
		if [[ "$columns" =~ ^[0-9]+$ ]] && (( columns > 0 )); then
			terminal_columns=columns
		else
			terminal_columns=80
		fi

		title_rows=$(rows_for_width "$title_width")
		for ((index = 0; index < ${#options[@]}; index++)); do
			option_rows[index]=$(rows_for_width "${option_widths[index]}")
		done
		status_rows=$(rows_for_width "$(visible_width "$(status_text)")")
	}

    # 初期化
	for ((i = 0; i < ${#options[@]}; i++)); do
		selected[i]=0
	done
	title_width=$(visible_width "$title $help_text")
	for ((i = 0; i < ${#options[@]}; i++)); do
		option_widths[i]=$(visible_width "$(option_text "$i")")
	done

	# 前回描画したフレームを消すエスケープシーケンスを作る。
	clear_rendered_rows() {
		local -i row
		local output=$'\r'

		for ((row = 0; row < rendered_rows; row++)); do
			output+=$'\033[1A\033[2K'
		done
		printf '%s' "$output"
	}

	# プロンプトをリセット
	reset_prompt() {
		printf '%s' "$(clear_rendered_rows)" >&2
	}

    # 描画関数
    draw() {
		local frame

		frame=$(clear_rendered_rows)
		update_layout

		# 消去と再描画を一度に出力して、途中状態のちらつきを防ぐ。
		frame+="$(fcolor 135)$title$(normal) "
		frame+="$(disable)$(fgray)$help_text$(normal)"$'\n'

        for ((i = 0; i < ${#options[@]}; i++)); do
			frame+="$(flightgreen)"
            if [[ $i -eq $cursor ]]; then
				frame+="▶ "
            else
				frame+="  "
            fi

			frame+="$(normal)$(tag_text "$i")"

			[[ $i -eq $cursor ]] && frame+="$(underline)"

            if [[ ${selected[i]} -eq 1 ]]; then
				frame+="$(flightgreen) ${aka[i]} "
            else
				frame+="$(disable)$(fgray) ${aka[i]} "
            fi
			frame+="$(normal)"$'\n'
        done

		frame+="$selected_count "
		[[ $limit -lt 999 ]] && frame+="/ $limit "
		frame+="Selected"
		[[ $selected_count -lt $min ]] && frame+=", $(fred)$((min - selected_count))$(normal) more."
		frame+=$'\n'

		rendered_rows=$((title_rows + status_rows))
		for ((i = 0; i < ${#options[@]}; i++)); do
			rendered_rows=$((rendered_rows + option_rows[i]))
		done

		printf '%s' "$frame" >&2
    }

    # メインループ
    while true; do
        draw

		INPUT=$(read_key)
        case "$INPUT" in
            'Up' | 'k')  # 上キーまたはk
                cursor=$(( (cursor - 1 + ${#options[@]}) % ${#options[@]} ))
                ;;
            'Down' | 'j')  # 下キーまたはj
                cursor=$(( (cursor + 1) % ${#options[@]} ))
                ;;
            'Space')  # スペースキー
                if [[ ${selected[cursor]} -eq 0 && $selected_count -lt $limit ]]; then
                    selected[cursor]=1
                    selected_count=$((selected_count + 1))
				elif [[ ${selected[cursor]} -eq 1 ]]; then
					selected[cursor]=0
					selected_count=$((selected_count - 1))
                fi
                ;;
			'a')  # aキー
				if [[ $selected_count -ne 0 ]]; then
					for ((i = 0; i < ${#options[@]}; i++)); do
						selected[i]=0
					done
					selected_count=0
				else
					for ((i = 0; i < ${#options[@]}; i++)); do
						if [[ $selected_count -ge $limit ]]; then
							break
						fi
						selected[i]=1
						selected_count=$((selected_count + 1))
					done
				fi
				;;
            'CR')  # エンターキー
				if [[ $selected_count -ge $min ]]; then
                	break
				fi
                ;;
			'q')  # qキー
				reset_prompt
				return 0
        esac
    done

	reset_prompt

    # 結果を表示
    for ((i = 0; i < ${#options[@]}; i++)); do
        if [[ ${selected[i]} -eq 1 ]]; then
            echo "${options[i]}"
        fi
    done

	return 0
}
