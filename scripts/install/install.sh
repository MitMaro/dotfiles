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

function stow_directory() {
	source_root="$__DOTS_DIR/$1"
	source_dir="$2"
	target_dir="${3:-}"

	if [[ -n "$target_dir" ]]; then
		target_dir="$target_dir/"
	fi

	for pkg_dir in "$source_root/$source_dir/"*; do
		package_name="$(basename "$pkg_dir")"
		stow_target="$TARGET_ROOT/$target_dir/$package_name"

		mkdir -p "$stow_target"
		stow "${stow_args[@]}" --target "$stow_target" --dir "$source_root/$source_dir/" "$package_name"
	done
}

stow "${stow_args[@]}" --dir "$__DOTS_DIR/install" --target "$TARGET_ROOT" root
stow_directory "install" ".config" ".config"
stow_directory "install" ".local" ".local"

stow "${stow_args[@]}" --dir "$__DOTS_DIR/install/build" --target "$TARGET_ROOT" root
stow_directory "install/build/.local" "share" ".local/share"
stow_directory "install/build/.local" "bin" ".local/bin"
stow_directory "install/build" ".zsh" ".zsh"
stow_directory "install/build/.vim/" "pack" ".vim/pack"

# just make sure this file exists
touch "$HOME/.gitconfig_local"
