export __DOTS_FIRST_RUN=0

___prompt_setup() {
	local EXITSTATUS="$?" prompt_end user_color prompt_color prompt_symbol run_time
	run_time=$(( $(date +"%s%3N") - $__DOTS_COMMAND_START_TIME ))

	if [[ ${run_time} -lt 1000 ]]; then
		run_time="${run_time} ms"
	elif [[ ${run_tim} -lt 60001 ]]; then # 60 minutes
		run_time="$(( ${run_time}/1000 )).${run_time: -4} s"
	fi

	if [[ $UID -eq 0 ]]; then
		user_color=${COLOR_RED}
	else
		user_color=${__PROMPT_USER_COLOR:-$COLOR_DARK_CYAN}
	fi
	prompt_color=${COLOR_GREEN}

	if [[ ${EXITSTATUS} -eq 0 ]]; then
		prompt_symbol="\[$COLOR_GREEN\]$EXITSTATUS\[$COLOR_NORMAL\]"
	else
		prompt_symbol="\[$COLOR_RED\]$EXITSTATUS"
	fi

	if [[ ${__DOTS_PREVIOUS_COMMAND} == "clear" ]]; then
		export __DOTS_FIRST_RUN=0
	fi

	if [[ ${__DOTS_FIRST_RUN} -eq 0 ]]; then
		export __DOTS_FIRST_RUN=1
	else
		prompt_end="\[$prompt_color\]└─┨$prompt_symbol\[$prompt_color\]┃ \[$COLOR_DARK_MAGENTA\]$run_time\[$prompt_color\]\n\n"
	fi

	PS1="${prompt_end}\[$prompt_color\]┌ \$(___check_jobs)\$(___check_git)\$(___node_version)\[$user_color\]\u \[$prompt_color\]\
\w (\$(ls -1 | wc -l | sed 's: ::g') files)\$(___check_git_branch_info)\
\[$prompt_color\] \[$prompt_color\]\n\
├▪ \[$COLOR_NORMAL\]"
	
	PS2="\[$prompt_color\]├▫ \[$COLOR_NORMAL\]"

	export __DOTS_IN_COMMAND=0
}

PROMPT_COMMAND="${PROMPT_COMMAND}___prompt_setup;"
