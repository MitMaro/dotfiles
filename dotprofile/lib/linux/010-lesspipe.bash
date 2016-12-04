
if [[ ! -x "/usr/bin/lesspipe" ]]; then
	__DEBUG_MESSAGE "lesspipe not installed, skipping."
	return
fi
eval "$(SHELL=/bin/sh lesspipe)"
