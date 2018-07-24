: '
dots - A dot files manager
By: Tim Oram
'

# check for Bash and interactive shell
([ -z $BASH ] || [[ ! "$-" =~ .*i.* ]]) && return;

# remove all existing aliases
unalias -a

# reset a few things
export PROMPT_COMMAND=""
export PATH="$(getconf PATH)"

export __DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -e "${__DOTS_DIR}/config.bash" ]] && source "${__DOTS_DIR}/config.bash"
source "${__DOTS_DIR}/dotprofile/lib/debug-log.bash"

__DEBUG_MESSAGE "Dots Directory: ${__DOTS_DIR}"

__load_dots_directories() {
	local subdirectory="$1"
	local os="$2"
	local distro="$3"
	local version="$4"

	__load_dots_files "${subdirectory}/common"
	if [[ ! -z "$os" ]]; then
		__load_dots_files "${subdirectory}/${os}"
		if [[ ! -z "$distro" ]]; then
			__load_dots_files "${subdirectory}/${os}.${distro}"
			if [[ ! -z "$version" ]]; then
				__load_dots_files "${subdirectory}/${os}.${distro}.${version}"
			fi
		fi
	fi

}

__load_dots_files() {
	local subdirectory="$1"
	if [[ ! -d "${__DOTS_DIR}/${subdirectory}" ]]; then
		__DEBUG_MESSAGE "Skipping: ${__DOTS_DIR}/${subdirectory}, does not exist"
		return
	fi
	local FILES="${__DOTS_DIR}/${subdirectory}/*.bash"
	for config_file in ${FILES}; do
		if [[ -e "${config_file}" ]]; then
			__DEBUG_MESSAGE "Sourcing: ${config_file}"
			source "${config_file}"
		fi
	done
}

__dots_load() {
	local os="$(uname)"
	local distro=
	local version=
	
	if [[ "$os" == "Darwin" ]]; then
		os="osx"
	elif [[ "$os" == "Linux" ]]; then
		os="linux"
		distro="$(lsb_release -si)"
		version="$(lsb_release -sr)"
	else
		os=""
		__DEBUG_MESSAGE "Unsupported operating system: ${os}";
	fi

	__load_dots_directories "dotprofile/lib" "${os}" "${distro}" "${version}"
	__load_dots_directories "dotprofile/includes" "${os}" "${distro}" "${version}"
	__load_dots_directories "dotprofile/aliases" "${os}" "${distro}" "${version}"
	__load_dots_directories "dotprofile/bash_completions.d" "${os}" "${distro}" "${version}"
	__load_dots_files "dotprofile/local"

	__DEBUG_MESSAGE "Loading theme"
	__load_dots_directories "dotprofile/theme" "${os}" "${distro}" "${version}"
	source "${__DOTS_DIR}/dotprofile/theme/theme.bash"
}

__dots_load
