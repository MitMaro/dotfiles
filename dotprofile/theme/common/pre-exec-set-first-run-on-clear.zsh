
__dots-preexec-set-first-run-on-clear() {
	if [[ "$__DOTS_PREVIOUS_COMMAND" == "clear" || "$__DOTS_PREVIOUS_COMMAND" == "reset" ]]; then
		export __DOTS_FIRST_RUN=0
	fi
}

preexec_functions+=("__dots-preexec-set-first-run-on-clear")
