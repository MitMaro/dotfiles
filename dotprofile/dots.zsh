: '
dots - A dot files manager
By: Tim Oram
'

# remove all existing aliases
unalias -m '*'

# reset a few things
export PROMPT_COMMAND=""
#export PATH="$(getconf PATH)"

export __DOTS_DIR="$(cd "$(dirname "$(readlink -f "${(%):-%x}")")/.." && pwd)"
source "${__DOTS_DIR}/dotprofile/dots.sh"

__load_dots_files() {
	local subdirectory="$1"
	for config_file in ${__DOTS_DIR}/${1}/*.{zsh,sh}(.N); do
		if [[ -e "${config_file}" ]]; then
			__DEBUG_MESSAGE "Sourcing: ${config_file}"
			source "${config_file}"
		fi
	done
}

# Workaround for https://github.com/robbyrussell/oh-my-zsh/issues/1433
DEBIAN_PREVENT_KEYBOARD_CHANGES=yes
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[3~' delete-char

__dots_load 'zsh'
