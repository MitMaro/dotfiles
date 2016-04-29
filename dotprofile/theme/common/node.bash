___node_version() {
	local npm_prefix node_version
	npm_prefix=$(npm prefix 2>/dev/null) || return 1

	if [[ -e ${npm_prefix}"/package.json" ]]; then
		node_version=$(node --version 2>/dev/null) || return 1
		echo -e "$COLOR_GREEN(${COLOR_DARK_BLUE}$node_version$COLOR_GREEN) "
	fi
}
