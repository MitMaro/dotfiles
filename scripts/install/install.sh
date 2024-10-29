#!/usr/bin/env bash

set -euo pipefail

declare -a stow_args=(
	"--verbose=1"
)

TARGET_ROOT="$HOME"

__DOTS_STOW_DRY_RUN="${__DOTS_STOW_DRY_RUN:-false}"
if [[ "${__DOTS_STOW_DRY_RUN}" != "false" ]]; then
	stow_args+=("--simulate")
fi

stow "${stow_args[@]}" --dir "$__DOTS_DIR/build" --target "$TARGET_ROOT" .
