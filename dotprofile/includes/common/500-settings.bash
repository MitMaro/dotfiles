
# misc bash settings
shopt -s cdspell # cd fuzzy spelling
shopt -s no_empty_cmd_completion # stops empty line completions
shopt -s checkwinsize # correct wrap on resize
shopt -s globstar # correct wrap on resize

# history
shopt -s histappend # append to end of history file, don't overwrite
HISTCONTROL=ignoredups:ignorespace # ignore duplicate commands and space prepended commands
HISTFILESIZE=100000 # keep this many previous commands
HISTSIZE=100000 # similar to HISTFILESIZE
HISTIGNORE="ls:ls -la:history*:exit:git st" # ignore these commands
PROIMPT_COMMAND="history -a;$PROMPT_COMMAND"

# enable unicode if possible
avail_locales=`locale -a`
locale_order=("en_CA.utf8" "en_CA.UTF-8" "en_US.utf8" "en_CA.UTF-8")
for locale in "${locale_order[@]}"; do
	array_contains "$locale" ${avail_locales[@]}
	if [[ "$?" == "0" ]]; then
		export LC_CTYPE=${locale}
		break;
	fi
done
