#!/usr/bin/env bash

stow_args="--verbose=1 --target $HOME --dir $__DOTS_DIR/"

__DOTS_STOW_DRY_RUN="${__DOTS_STOW_DRY_RUN:-false}"
if ( ${__DOTS_STOW_DRY_RUN} ); then
	stow_args="$stow_args --simulate"
fi

stow ${stow_args} build
stow ${stow_args} bin
stow ${stow_args} git
stow ${stow_args} shell

# just make sure this file exists
touch "$HOME/.gitconfig_local"
