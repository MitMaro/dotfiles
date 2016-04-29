: '
dots - A dot files manager
By: Tim Oram
'

# reset a few things
export PROMPT_COMMAND=""
export PATH=$(getconf PATH);

export __DOTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${__DOTS_DIR}/config.bash"
source "${__DOTS_DIR}/dotprofile/lib/debug-log.bash"

__DEBUG_MESSAGE "Dots Directory: ${__DOTS_DIR}"

__load_dots_files() {
	local subdirectory="$1"
	if [ ! -d "${__DOTS_DIR}/${subdirectory}" ]; then
		__DEBUG_MESSAGE "Skipping ${__DOTS_DIR}/${subdirectory} as it does not exist"
		continue
	fi
	local FILES="${__DOTS_DIR}/${subdirectory}/*.bash"
	for config_file in ${FILES}; do
		if [ -e "${config_file}" ]; then
			__DEBUG_MESSAGE "Sourcing: ${config_file}"
			source ${config_file}
		fi
	done
}

__dots_load() {
	
	local os=$(uname)
	
	if [[ "$os" == "Darwin" ]]; then
		os="osx"
	fi

	__load_dots_files "dotprofile/lib/common"
	__load_dots_files "dotprofile/lib/${os}"
	__load_dots_files "dotprofile/includes/common"
	__load_dots_files "dotprofile/includes/${os}"
	__load_dots_files "dotprofile/aliases/common"
	__load_dots_files "dotprofile/aliases/${os}"
	__load_dots_files "dotprofile/includes/bash_completions.d"
	__load_dots_files "dotprofile/local"

	__DEBUG_MESSAGE "Loading theme"
	__load_dots_files "dotprofile/theme/common"
	__load_dots_files "dotprofile/theme/${os}"
	source "${__DOTS_DIR}/dotprofile/theme/theme.bash"
}

__dots_load
