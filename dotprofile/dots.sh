
# this file is expected to be sourced from `dots.zsh` or `bash.zsh`

# reset a few things
export PROMPT_COMMAND=""
export PATH="$(getconf PATH)"

[[ -e "${__DOTS_DIR}/config.sh" ]] && source "${__DOTS_DIR}/config.sh"
source "${__DOTS_DIR}/dotprofile/lib/debug-log.sh"

__DEBUG_MESSAGE "Dots Directory: ${__DOTS_DIR}"

__load_dots_directories() {
	local subdirectory="$1"
	local os="$2"
	local distro="$3"
	local version="$4"

	__load_dots_directory "${subdirectory}/common"
	if [[ ! -z "$os" ]]; then
		__load_dots_directory "${subdirectory}/${os}"
		if [[ ! -z "$distro" ]]; then
			__load_dots_directory "${subdirectory}/${os}.${distro}"
			if [[ ! -z "$version" ]]; then
				__load_dots_directory "${subdirectory}/${os}.${distro}.${version}"
			fi
		fi
	fi
}

__load_dots_directory() {
	local subdirectory="$1"
	if [[ ! -d "${__DOTS_DIR}/${subdirectory}" ]]; then
		__DEBUG_MESSAGE "Skipping: ${__DOTS_DIR}/${subdirectory}, does not exist"
		return
	fi
	__load_dots_files "$subdirectory"
}

__dots_load() {
	local extension="$1"
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

	if [[ -d "${HOME}/.local/.dot-files" ]]; then
		__load_dots_files "${HOME}/.local/.dot-files/post-load"
	fi

	__load_dots_directories "dotprofile/lib" "${os}" "${distro}" "${version}"
	__load_dots_directories "dotprofile/includes" "${os}" "${distro}" "${version}"
	__load_dots_directories "dotprofile/aliases" "${os}" "${distro}" "${version}"
	__load_dots_directories "dotprofile/bash_completions.d" "${os}" "${distro}" "${version}"

	if [[ -d "${HOME}/.local/.dot-files" ]]; then
		__load_dots_files "${HOME}/.local/.dot-files/post-load"
	fi


	__DEBUG_MESSAGE "Loading theme"
	__load_dots_directories "dotprofile/theme" "${os}" "${distro}" "${version}"
	source "${__DOTS_DIR}/dotprofile/theme/theme.${extension}"
}
