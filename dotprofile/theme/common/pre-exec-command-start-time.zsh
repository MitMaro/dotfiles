
__dots-preexec-command-start-time() {
	export __DOTS_COMMAND_START_SECONDS="$(date +'%s%3N')"
	export __DOTS_COMMAND_START_TIME="$(date +'%H:%M:%S')"
}

preexec_functions+=("__dots-preexec-command-start-time")
