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



    # 初期化
    for ((i = 0; i < ${#options[@]}; i++)); do
        selected[i]=0
		echo "" >&2 # 選択肢分の改行
    done
	echo "" >&2 # タイトル分の改行
	echo "" >&2 # ステータス分の改行

	# プロンプトをリセット
	reset_prompt() {
		cursor_begin >&2 # カーソルを行頭に移動
		# ステータス行をクリア
		cursor_up 1 >&2
		clear_line >&2
		for ((i = 0; i < ${#options[@]}; i++)); do
			# カーソルを一つ上に移動して行をクリア
			cursor_up 1 >&2
			clear_line >&2
		done
		# タイトル行をクリア
		cursor_up 1 >&2
		clear_line >&2
	}

    # 描画関数
    draw() {
		reset_prompt

		echo -en "$(fcolor 135)$title$(normal) " >&2
		echo -e "$(disable)$(fgray)↑/k: Up, ↓/j: Down, Space: Select, a: SelectAll, Enter: Confirm, q: Quit$(normal)" >&2

        for ((i = 0; i < ${#options[@]}; i++)); do
			flightgreen >&2
            if [[ $i -eq $cursor ]]; then
                echo -n "▶ " >&2
            else
                echo -n "  " >&2
            fi

			normal >&2  # 色をリセット
			echo -en "${tags[i]}" >&2

			[[ $i -eq $cursor ]] && underline >&2

            if [[ ${selected[i]} -eq 1 ]]; then
				flightgreen >&2
				echo -e " ${aka[i]} " >&2
            else
				disable >&2; fgray >&2
				echo -e " ${aka[i]} " >&2
            fi
            normal >&2  # 色をリセット
        done

		echo -e "$selected_count $(if [[ $limit -lt 999 ]]; then echo "/ $limit "; fi)Selected$(if [[ $selected_count -lt $min ]]; then echo -e ", $(fred)$((min - selected_count))$(normal) more."; fi)" >&2
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
