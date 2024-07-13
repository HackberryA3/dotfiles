httpserver() {
	local port="${1:-8000}"
	if (which "python" > /dev/null 2>&1); then
		python -m http.server "$port"
	elif (which "python3" > /dev/null 2>&1); then
		python3 -m http.server "$port"
	elif (which "php" > /dev/null 2>&1); then
		php -S "localhost:$port"
	else
		echo "Error: Python or PHP is not installed." >&2
		return 1
	fi
}
