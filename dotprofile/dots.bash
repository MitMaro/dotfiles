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
	local dots_dir="$__DOTS_DIR"
	if [[ "$subdirectory" = /* ]]; then
		# remove leading slash
		subdirectory="${subdirectory:1}"
		# no root directory
		dots_dir=""
	fi
	for config_file in ${dots_dir}/${subdirectory}/*.{bash,sh}; do
		if [[ -e "${config_file}" ]]; then
			__DEBUG_MESSAGE "Sourcing: ${config_file}"
			source "${config_file}"
		fi
	done
}


__dots_load 'bash'
