#!/usr/bin/env bash

if ! command -v "stow" > /dev/null; then
	>&2 echo "Command stow not found, aborting"
	exit 1
fi

export __DOTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"

cat <<-EOF > "$__DOTS_DIR/shell/.bash_profile"
	# this file is auto generated by a script, modifications will be overwritten
	[ -n "\$PS1" ] && source "$__DOTS_DIR/dots.bash"
EOF

stow_args="--verbose=1 --target $HOME --dir $__DOTS_DIR/"

__DOTS_STOW_DRY_RUN="${__DOTS_STOW_DRY_RUN:-false}"
if ( ${__DOTS_STOW_DRY_RUN} ); then
	stow_args="$stow_args --simulate"
fi

ln -sfn "$__DOTS_DIR/dependencies/diff-so-fancy/diff-so-fancy" "$__DOTS_DIR/bin/.bin/diff-so-fancy"

stow ${stow_args} bin
stow ${stow_args} shell
stow ${stow_args} git

# just make sure this file exists
touch "$HOME/.gitconfig_local"

echo "Install complete"