
__DEBUG_MESSAGE() {
	__DOTS_DEBUG=${__DOTS_DEBUG:-false}
	if ( ${__DOTS_DEBUG} ); then
		>&2 echo "$*"
	fi
}
