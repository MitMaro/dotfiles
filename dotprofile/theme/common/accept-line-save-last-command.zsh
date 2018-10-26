__dots_accept_line () {
	export __DOTS_PREVIOUS_COMMAND="$BUFFER"
	zle .accept-line
}

zle -N accept-line __dots_accept_line
