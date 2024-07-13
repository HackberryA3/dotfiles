mkcontest() {
    local name=$1
    local problemCnt=$2

	usage() {
		echo "Usage: mkcontest NAME [PROBLEM_CNT]" >&2
		echo "  NAME: Contest name." >&2
		echo "  [PROBLEM_CNT]: Number of problems. You can omit this when the NAME is set to ABC, ARC, or AGC." >&2
	}

	if [[ -z $name ]]; then
		echo "Error: NAME is not specified." >&2
		usage
		return 1
	fi
    # nameがABC、ARCまたはAGCで始まる場合のproblemCntの自動設定
	if [[ -z $problemCnt ]]; then
		if [[ $name == ABC* ]]; then
			problemCnt=7
		elif [[ $name == ARC* || $name == AGC* ]]; then
			problemCnt=6
		else
			echo "Error: PROBLEM_CNT is not specified." >&2
			usage
			return 1
		fi
	fi

    # nameフォルダの作成
    mkdir -p "$name"
    
    # 問題フォルダとmain.cppの作成
    for ((i=0; i<problemCnt; i++)); do
		folder=$(printf "%s/%s" "$name" "$(awk "BEGIN{printf \"%c\", $((65+i))}")")
        mkdir -p "$folder"
        touch "$folder/main.cpp"
    done
}
