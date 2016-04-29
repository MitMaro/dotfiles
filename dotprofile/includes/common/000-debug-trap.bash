trap '__dots_debug_trap' DEBUG

__dots_debug_trap() {
	export __DOTS_PREVIOUS_COMMAND=${__DOTS_CURRENT_COMMAND};
	export __DOTS_CURRENT_COMMAND=$BASH_COMMAND

	if [[ "$__DOTS_IN_COMMAND" == "1" ]]; then
		return
	fi
	export __DOTS_IN_COMMAND=1
	
	export __DOTS_COMMAND_START_TIME=$(date +'%s%3N')
}
