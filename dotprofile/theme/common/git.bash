function ___check_git() {
	local base_dir
	base_dir=$(git rev-parse --show-cdup 2>/dev/null) || return 1
	echo -e "$COLOR_GREEN(${COLOR_YELLOW}git$COLOR_GREEN) "
}

function ___check_git_branch_info() {
	local base_dir modified_count ahead behind branch_status tmp
	
	branch_status=""

	git rev-parse --is-inside-work-tree > /dev/null 2>&1 || return 1

	tmp="$(git status --porcelain --branch | head -1 | sed 's/.*\[\(.*\)\]/\1/')"
	ahead="$(echo ${tmp} | grep "ahead" | sed 's/.*ahead \([0-9]*\).*/\1/')"
	behind="$(echo ${tmp} | grep "behind" | sed 's/.*behind \([0-9]*\).*/\1/')"
	if [ ! -z "${ahead}" ] || [ ! -z "${behind}" ]; then
		branch_status=" ${COLOR_LIGHT_GREY}["
		if [ ! -z "${ahead}" ]; then
			branch_status="${branch_status}${COLOR_WHITE}A ${COLOR_DARK_GREEN}${ahead}${COLOR_NORMAL}"
		fi
		
		if [ ! -z "${ahead}" ] && [ ! -z "${behind}" ]; then
			branch_status="${branch_status}, "
		fi
		
		if [ ! -z "${behind}" ]; then
			branch_status="${branch_status}${COLOR_WHITE}B ${COLOR_DARK_RED}${behind}${COLOR_NORMAL}"
		fi
		branch_status="${branch_status}${COLOR_LIGHT_GREY}]${COLOR_NORMAL}"
	fi
	
	base_dir=$(git rev-parse --show-cdup 2>/dev/null) || return 1
	
	modified_count=`git status --porcelain -uno | wc -l`
	if (( $modified_count > 0 )); then
		echo -e " $COLOR_GREEN($COLOR_RED$(__git_ps1 "%s")${branch_status}$COLOR_GREEN)"
	else
		echo -e " $COLOR_GREEN($COLOR_LIGHT_GREY$(__git_ps1 "%s")${branch_status}$COLOR_GREEN)"
	fi
}
