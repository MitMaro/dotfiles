: '
dots - A dot files manager
By: Tim Oram
'

# check for Bash and interactive shell
([ -z $BASH ] || [[ ! "$-" =~ .*i.* ]]) && return;

# remove all existing aliases
unalias -a

export __DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${__DOTS_DIR}/dotprofile/dots.sh"

__load_dots_files() {
	local subdirectory="$1"
	for config_file in ${__DOTS_DIR}/${subdirectory}/*.{bash,sh}; do
		echo $config_file
		if [[ -e "${config_file}" ]]; then
			__DEBUG_MESSAGE "Sourcing: ${config_file}"
			source "${config_file}"
		fi
	done
}


__dots_load 'bash'
