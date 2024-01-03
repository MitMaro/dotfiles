#!/usr/bin/env bash

>&2 echo "Uninstalling needs an update before running"
exit 1

if ! command -v "stow" > /dev/null; then
	>&2 echo "Command stow not found, aborting"
	exit 1
fi

export __DOTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"

stow_args="--verbose=1 --delete --target $HOME --dir $__DOTS_DIR/"

__DOTS_STOW_DRY_RUN=${__DOTS_STOW_DRY_RUN:-false}
if ( ${__DOTS_STOW_DRY_RUN} ); then
	stow_args="$stow_args --simulate"
fi

stow ${stow_args} config
stow ${stow_args} bin
stow ${stow_args} git
stow ${stow_args} shell

# just make sure this file exists
touch "$HOME/.gitconfig_local"

echo "Uninstall complete"
