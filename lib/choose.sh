#!/bin/bash

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
    local INPUT

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
					echo -e "\e[31mError: aka must be after args.\e[0m" >&2
					return 1
				fi
				for (( i = 0; i < ${#options[@]}; i++ )); do
					shift
					if [[ -z "$1" ]]; then
						echo -e "\e[31mError: The number of aka must be the same as the number of options\e[0m" >&2
						return 1
					fi
					aka[i]="$1"
				done
				;;
			--tag)
				if [[ $HAS_ARGS = false ]]; then
					echo -e "\e[31mError: tag must be after args.\e[0m" >&2
					return 1
				fi
				for (( i = 0; i < ${#options[@]}; i++ )); do
					shift
					if [[ -z "$1" ]]; then
						echo -e "\e[31mError: The number of tag must be the same as the number of options\e[0m" >&2
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
			echo -e "\e[31mError: choose is not supported with pipe\e[0m" >&2
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
		echo -e "\e[31mError: min must be less than or equal to limit\e[0m" >&2
		return 1
	fi
	if [[ $min -lt 0 ]]; then
		echo -e "\e[31mError: min must be greater than or equal to 0\e[0m" >&2
		return 1
	fi
	if [[ $limit -lt 0 ]]; then
		echo -e "\e[31mError: limit must be greater than or equal to 0\e[0m" >&2
		return 1
	fi
	# akaがなければ、akaを選択肢と同じにする
	if [[ ${#aka[@]} -eq 0 ]]; then
		aka=("${options[@]}")
	fi
	# akaが指定されている場合、選択肢の数と一致するか確認
	if [[ ${#aka[@]} -ne ${#options[@]} ]]; then
		echo -e "\e[31mError: The number of aka must be the same as the number of options\e[0m" >&2
		echo -e "\e[31maka: ${#aka[@]}, options: ${#options[@]}\e[0m" >&2
		echo -e "\e[31maka: ${aka[*]}\e[0m" >&2
		echo -e "\e[31moptions: ${options[*]}\e[0m" >&2
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
		echo -en "\r" >&2 # カーソルを行頭に移動
		echo -en "\e[1A\e[K" >&2 # ステータス行をクリア
		for ((i = 0; i < ${#options[@]}; i++)); do
			echo -en "\e[1A\e[K" >&2 # カーソルを一つ上に移動して行をクリア
		done
		echo -en "\e[1A\e[K" >&2 # タイトル行をクリア
	}

    # 描画関数
    draw() {
		reset_prompt

		echo -e "\e[38;05;135m$title\e[0m" >&2

        for ((i = 0; i < ${#options[@]}; i++)); do
			echo -en "\e[38;05;077m" >&2
            if [[ $i -eq $cursor ]]; then
                echo -n "▶ " >&2
            else
                echo -n "  " >&2
            fi

			echo -en "\e[0m" >&2  # 色をリセット
			echo -en "${tags[i]}" >&2

			[[ $i -eq $cursor ]] && echo -en "\e[4m" >&2

            if [[ ${selected[i]} -eq 1 ]]; then
				echo -en "\e[38;05;077m" >&2
				echo -e " ${aka[i]} " >&2
            else
				echo -en "\e[38;05;246m" >&2
				echo -e " ${aka[i]} " >&2
            fi
            echo -en "\e[0m" >&2  # 色をリセット
        done

		echo -e "$selected_count $(if [[ $limit -lt 999 ]]; then echo "/ $limit "; fi)Selected$(if [[ $selected_count -lt $min ]]; then echo -e ", \e[31m$((min - selected_count))\e[0m more."; fi)" >&2
    }

    # キー入力処理
    read_input() {
        IFS= read -r -s -n1 INPUT 
        if [[ "$INPUT" == $'\x1b' ]]; then
            read -r -s -n2 INPUT  # 矢印キー読み取り
        fi
    }

    # メインループ
    while true; do
        draw

        read_input

        case "$INPUT" in
            '[A' | 'k')  # 上キーまたはk
                cursor=$(( (cursor - 1 + ${#options[@]}) % ${#options[@]} ))
                ;;
            '[B' | 'j')  # 下キーまたはj
                cursor=$(( (cursor + 1) % ${#options[@]} ))
                ;;
            ' ')  # スペースキー
                if [[ ${selected[cursor]} -eq 0 && $selected_count -lt $limit ]]; then
                    selected[cursor]=1
                    selected_count=$((selected_count + 1))
				elif [[ ${selected[cursor]} -eq 1 ]]; then
					selected[cursor]=0
					selected_count=$((selected_count - 1))
                fi
                ;;
            '')  # エンターキー
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
