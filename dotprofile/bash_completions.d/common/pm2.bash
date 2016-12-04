if hash pm2 2>/dev/null; then
	__DEBUG_MESSAGE "Loading completions for pm2"
	COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
	COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
	export COMP_WORDBREAKS
	
	_pm2_completion () {
		local si="$IFS"
		IFS=$'\n' COMPREPLY=( \
			$(COMP_CWORD="$COMP_CWORD" \
			COMP_LINE="$COMP_LINE" \
			COMP_POINT="$COMP_POINT" \
			pm2 completion -- "${COMP_WORDS[@]}" \
			2>/dev/null)
		) || return $?
		IFS="$si"
	}
	complete -o default -F _pm2_completion pm2

fi
