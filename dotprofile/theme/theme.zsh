
# load git info
autoload -Uz vcs_info

# let commands be run as part of the prompt
setopt PROMPT_SUBST

export __DOTS_FIRST_RUN=0
export __DOTS_COMMAND_START_SECONDS=0
# https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
___prompt_directory_marker_fg="208"
___prompt_directory_marker_bg="237"
___prompt_git_bg="237"
___prompt_git_fg="253"
___prompt_git_added_fg="022"
___prompt_git_removed_fg="166"
___prompt_git_modified_fg="124"
___prompt_jobs_fg="250"
___prompt_jobs_bg="016"
___prompt_user_fg="255"
___prompt_user_bg="033"
___prompt_node_fg="077"
___prompt_rust_fg="166"
___prompt_project_bg="238"
___prompt_project_fg="248"
___prompt_path_fg="255"
___prompt_path_bg="022"
___prompt_path_stats_fg="250"
___prompt_path_stats_bg="016"
___prompt_code_success_fg="028"
___prompt_code_error_fg="124"
___prompt_code_bg="233"
___prompt_runtime_fg="255"
___prompt_runtime_bg="132"
___prompt_prompt_shadow="237"

typeset -g ___prompt_exit_status
___prompt_exit_status=0
typeset -g ___prompt_run_time
___prompt_run_time=0
typeset -g ___prompt_command_date_time
___prompt_command_date_time=0

typeset -Ag ___prompt_elements
typeset -Ag ___prompt_elements_transition_foreground
typeset -Ag ___prompt_elements_transition_background
typeset -Ag ___prompt_elements_transition_symbol
typeset -Ag ___prompt_elements_transition_inverse
typeset -Ag ___prompt_elements_transition_disable

___prompt-separator() {
	local left_color="$1"
	local right_color="$2"
	local character="${3:=\UE0B0}"

	if [[ -n "$left_color" ]]; then
		print -n -P "%F{$left_color}"
	else
		print -n -P "%f"
	fi

	if [[ -n "$right_color" ]]; then
		print -n -P "%K{$right_color}"
	else
		print -n -P "%k"
	fi

	print -n "$character"
}

___prompt_elements[lead]=""
___prompt_elements_transition_foreground[lead]=""
___prompt_elements_transition_background[lead]=""
___prompt_elements_transition_symbol[lead]='\UE0C5'
___prompt_elements_transition_inverse[lead]="true"

___prompt_elements[jobs]="___prompt-jobs"
___prompt_elements_transition_foreground[jobs]="$___prompt_jobs_bg"
___prompt_elements_transition_background[jobs]="$___prompt_jobs_fg"
___prompt_elements_transition_symbol[jobs]='\UE0C4'
___prompt-jobs() {
	local job_count="$(jobs -p | wc -l)"
	if [[ "$job_count" == "0" ]]; then
		return
	fi
	job_count=10

	print -n -P "%F{$___prompt_jobs_fg}%K{$___prompt_jobs_bg}"
	print -n "$job_count"
}

___prompt_elements[directory_marker]='___prompt-directory-marker'
___prompt_elements_transition_foreground[directory_marker]="$___prompt_directory_marker_bg"
___prompt_elements_transition_background[directory_marker]="$___prompt_directory_marker_fg"
___prompt_elements_transition_symbol[directory_marker]='\UE0C6'
___prompt-directory-marker() {
	print -n -P "%F{$___prompt_directory_marker_fg}%K{$___prompt_directory_marker_bg}"
	if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1 ; then
		print -n "\UE725" # git symbol
	else
		print -n "\UFD24"
	fi
}

___prompt_elements[user]='___prompt-user'
___prompt_elements_transition_foreground[user]="$___prompt_user_bg"
___prompt_elements_transition_background[user]="$___prompt_user_fg"
___prompt_elements_transition_symbol[user]='\UE0B0'
___prompt-user() {
	print -n -P "%F{$___prompt_user_fg}%K{$___prompt_user_bg}"
	print -n -P "%n "
}

___prompt_elements[dir_stats]='___prompt-dir-stats'
___prompt_elements_transition_foreground[dir_stats]="$___prompt_path_stats_bg"
___prompt_elements_transition_background[dir_stats]="$___prompt_path_stats_fg"
___prompt_elements_transition_symbol[dir_stats]='\UE0B6'
___prompt_elements_transition_inverse[dir_stats]="true"
___prompt-dir-stats() {
	print -n -P "%F{$___prompt_path_stats_fg}%K{$___prompt_path_stats_bg}"
	print -n " $(ls -A1q | wc -l) "
}

___prompt_elements[path]='___prompt-path'
___prompt_elements_transition_foreground[path]="$___prompt_path_bg"
___prompt_elements_transition_background[path]="$___prompt_path_fg"
___prompt_elements_transition_symbol[path]='\UE0C6'
___prompt-path() {
	print -n -P "%F{$___prompt_path_fg}%K{$___prompt_path_bg}"
	print -n -P " %~ "
}

___prompt_elements[project_info]='___prompt-project-info'
___prompt_elements_transition_foreground[project_info]="$___prompt_project_bg"
___prompt_elements_transition_background[project_info]="$___prompt_project_fg"
___prompt_elements_transition_symbol[project_info]='\UE0C6'
___prompt-project-info() {
	local project_prompt=""
	local project_root
	local has_info=0
	local has_node=0
	local has_rust=0
	local has_previous=0

	if get-project-root node &> /dev/null; then
		has_info=1
		has_node=1
	fi

	if get-project-root rust &> /dev/null; then
		has_info=1
		has_rust=1
	fi

	if [[ "$has_info" == "0" ]]; then
		return
	fi

	print -n -P "%K{$___prompt_project_bg} "

	if [[ "$has_node" == "1" ]]; then
		node_version="$(node --version 2>/dev/null)"
		if [[ "$?" == "0" ]]; then
			has_previous=1
			print -n -P "%F{$___prompt_node_fg}"
			print -n "${node_version:1}"
			print -n "\UE60C";
		fi
	fi

	if [[ "$has_rust" == "1" ]]; then
		rust_version="$(rustc --version | awk '{print $2}' 2>/dev/null)"
		if [[ "$?" == "0" ]]; then
			if [[ "$has_previous" == "1" ]]; then
				___prompt-separator $___prompt_project_fg $___prompt_project_bg '\UE0BB'
			fi
			has_previous=1
			print -n -P "%F{$___prompt_rust_fg}"
			print -n "$rust_version"
			print -n "\UE7A8";
		fi
	fi

	if [[ "$has_info" != "0" ]]; then
		print -n " "
	fi
}

___prompt_elements[git_info]='___prompt-git-info'
___prompt_elements_transition_foreground[git_info]="$___prompt_git_bg"
___prompt_elements_transition_background[git_info]="$___prompt_git_fg"
___prompt_elements_transition_symbol[git_info]='\UE0B4'
___prompt-git-info() {
	local base_dir
	local modified_count
	local ahead
	local behind
	local branch_status
	local tmp

	git rev-parse --is-inside-work-tree > /dev/null 2>&1 || return 0

	print -n -P "%K{$___prompt_git_bg}%F{$___prompt_git_fg}"

	base_dir=$(git rev-parse --show-cdup 2>/dev/null) || return 1
	modified_count=`git status --porcelain -uno | wc -l`
	if [[ "$modified_count" > "0" ]]; then
		print -n -P "%F{$___prompt_git_modified_fg}"
	fi
	__git_ps1 " %s "

	tmp="$(git status --porcelain --branch | head -1 | sed 's/.*\[\(.*\)\]/\1/')"
	ahead="$(echo "$tmp" | grep "ahead" | sed 's/.*ahead \([0-9]*\).*/\1/')"
	behind="$(echo "$tmp" | grep "behind" | sed 's/.*behind \([0-9]*\).*/\1/')"
	if [ ! -z "${ahead}" ] || [ ! -z "${behind}" ]; then
		if [ ! -z "${ahead}" ]; then
			print -n -P "%F{$___prompt_git_added_fg}"
			print -n "\UF067"
			print -n "${ahead}"
		fi

		if [ ! -z "${ahead}" ] && [ ! -z "${behind}" ]; then
			print -n -P "%F{$___prompt_git_fg}"
			print -n "\UE621"
		fi

		if [ ! -z "${behind}" ]; then
			print -n -P "%F{$___prompt_git_removed_fg}"
			print -n "\UF068"
			print -n "${behind}"
		fi
	fi
}

___prompt_elements[prompt_tail]=""
___prompt_elements_transition_foreground[prompt_tail]=""
___prompt_elements_transition_background[prompt_tail]=""
___prompt_elements_transition_symbol[prompt_tail]=''

___prompt_elements[prompt_input]=""
___prompt_elements_transition_foreground[prompt_input]=""
___prompt_elements_transition_background[prompt_input]=""
___prompt_elements_transition_symbol[prompt_input]='\UE0C6'
___print-prompt-input() {
	if [[ "$___prompt_exit_status" -eq "0" || -z "$__DOTS_PREVIOUS_COMMAND" ]]; then
		print -n "%{%F{$___prompt_code_success_fg}%k%}"
	else
		print -n "%{%F{$___prompt_code_error_fg}%k%}"
	fi
	print -n '\U2771 '
	print -n "%f%k"
}

___prompt_elements[status_lead]=""
___prompt_elements_transition_foreground[status_lead]=""
___prompt_elements_transition_background[status_lead]=""
___prompt_elements_transition_symbol[status_lead]='\UE0B6'
___prompt_elements_transition_inverse[status_lead]="true"

___prompt_elements[status_code]='___print-status-code'
___prompt_elements_transition_foreground[status_code]="$___prompt_code_bg"
___prompt_elements_transition_background[status_code]="$___prompt_code_success_fg"
___prompt_elements_transition_symbol[status_code]='\U2588\UE0B0'
___print-status-code() {
	print -n -P "%K{$___prompt_code_bg}"

	if [[ "$___prompt_exit_status" -eq "0" ]]; then
		print -n -P "%F{$___prompt_code_success_fg}"
	else
		print -n -P "%F{$___prompt_code_error_fg}"
	fi

	print -n "$___prompt_exit_status"
}

___prompt_elements[status_runtime]='___print-status-runtime'
___prompt_elements_transition_foreground[status_runtime]="$___prompt_runtime_bg"
___prompt_elements_transition_background[status_runtime]="$___prompt_runtime_fg"
___prompt_elements_transition_symbol[status_runtime]='\UE0B4'
___print-status-runtime() {
	print -n -P "%F{$___prompt_runtime_fg}%K{$___prompt_runtime_bg}"

	if [[ "${___prompt_run_time}" -lt "1000" ]]; then
		print -n " ${___prompt_run_time}ms"
	elif [[ "${run_tim}" -lt "60001" ]]; then # 60 minutes
		print -n " $(( ${___prompt_run_time}/1000 )).${___prompt_run_time: -4}s"
	fi

	print -n ' \UF253 '
	# only add end time if it is different than start
	if [[ "$___prompt_command_date_time" == "$__DOTS_COMMAND_START_TIME" ]]; then
		print -n "$__DOTS_COMMAND_START_TIME"
	else
		print -n "$__DOTS_COMMAND_START_TIME \UF48B $___prompt_command_date_time"
	fi
}

___prompt_elements[status_tail]=""
___prompt_elements_transition_foreground[status_tail]=""
___prompt_elements_transition_background[status_tail]="$___prompt_code_success_fg"
___prompt_elements_transition_symbol[status_tail]=''
___prompt_elements_transition_inverse[status_tail]="true"

___prompt-build() {
	local previous_transition_foreground
	local previous_transition_background
	local previous_transition_symbol
	local previous_elements_transition_inverse
	local prompt_items

	if [[ "${__DOTS_FIRST_RUN}" -eq "1" && -n "$__DOTS_PREVIOUS_COMMAND" ]]; then
		prompt_items=("${___prompt_status_order[@]}" "newline" "${___prompt_order[@]}")
	else
		prompt_items=("${___prompt_order[@]}")
	fi

	for name in $prompt_items; do
		out=""
		if [[ -n "$___prompt_elements[$name]" ]]; then
			out="$("$___prompt_elements[$name]")"
			if [[ -z "$out" ]]; then
				continue
			fi
		fi
		if [[ -n "$previous_transition_symbol" && "$___prompt_elements_transition_disable[$name]" != "true" ]]; then
			if [[ "$previous_elements_transition_inverse" == "true" ]]; then
				___prompt-separator "${___prompt_elements_transition_foreground[$name]}" "$previous_transition_foreground"  "$previous_transition_symbol"
			else
				___prompt-separator "$previous_transition_foreground" "${___prompt_elements_transition_foreground[$name]}" "$previous_transition_symbol"
			fi
		fi
		if [[ "$name" == "newline" ]]; then
			printf $'\n'
		fi
		print -n -P "$reset_color"
		print -n "$out"
		previous_transition_foreground="${___prompt_elements_transition_foreground[$name]}"
		previous_transition_background="${___prompt_elements_transition_background[$name]}"
		previous_transition_symbol="${___prompt_elements_transition_symbol[$name]}"
		previous_elements_transition_inverse="${___prompt_elements_transition_inverse[$name]}"
	done
}

___prompt-setup() {
	___prompt_exit_status="$?"
	___prompt_run_time="$(( $(date +"%s%3N") - $__DOTS_COMMAND_START_SECONDS ))"
	___prompt_command_date_time="$(date +'%H:%M:%S')"

	___prompt-build
	# The last line of the prompt must be in PS1 since the last outputted line is always replace with the value in PS1
	PS1="$(___print-prompt-input)"
	if [[ "${__DOTS_FIRST_RUN}" -eq "0" ]]; then
		__DOTS_FIRST_RUN=1
	fi
	__DOTS_PREVIOUS_COMMAND=""
}

___prompt_status_order=(
	"status_lead"
	"status_code"
	"status_runtime"
	"status_rundate"
	"status_tail"
)

___prompt_order=(
	"lead"
	"jobs"
	"directory_marker"
	"user"
	"git_info"
	"project_info"
	"dir_stats"
	"path"
	"prompt_tail"
	"newline"
)
RPROMPT=

# don't print a trailing character on output that does not end in a newline
PROMPT_EOL_MARK=

precmd_functions+=(___prompt-setup)

## Cool idea for later with collapsible prompt: https://superuser.com/questions/1027957/zsh-change-prompt-just-before-command-is-run#1029103
#
# Update time in prompt
#TMOUT=15
#
#TRAPALRM() {
#    zle reset-prompt
#}
#RPROMPT=
#
#RPROMPT='%D{%L:%M %p}'
#
#TMOUT=15
#
#TRAPALRM() {
#    zle reset-prompt
#}

## Idea
## Use hook to have animated hour glass in RPROMPT while command runs
