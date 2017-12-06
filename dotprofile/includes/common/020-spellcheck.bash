
if ! type aspell &> /dev/null; then
	__DEBUG_MESSAGE "aspell not installed, skipping spellcheck install."
	return
fi

spellcheck() {
	aspell -a --suggest --ignore-case <<< "$@" | tail --lines=+2
}
