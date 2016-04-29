
if [ ! -x /usr/local/bin/lesspipe.sh ]; then
	__DEBUG_MESSAGE "lesspipe not installed, skipping."
	return
fi
eval "$(SHELL=/bin/sh lesspipe.sh)"
