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
	local dots_dir="$__DOTS_DIR"
	if [[ "$subdirectory" = /* ]]; then
		# remove leading slash
		subdirectory="${subdirectory:1}"
		# no root directory
		dots_dir=""
	fi
	for config_file in ${dots_dir}/${subdirectory}/*.{zsh,sh}(.N); do
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

# since EDITOR=vim on reload, this forces line editor to be in emacs mode
bindkey -e

__dots_load 'zsh'
