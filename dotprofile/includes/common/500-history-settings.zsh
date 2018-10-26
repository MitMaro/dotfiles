## history

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
setopt hist_reduce_blanks     # remove superfluous blanks before recording entry.

HISTSIZE=100000
SAVEHIST=$HISTSIZE
HISTORY_IGNORE="(ls|ls -la|history\s.*|exit|git st)" # ignore these commands

# see https://github.com/zsh-users/zsh-history-substring-search
