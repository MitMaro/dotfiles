#!/usr/bin/env bash

download-cached() {
	target="$__DOTS_INSTALL_TMP/$1"
	url="$2"
	if [ -e "$target" ]; then
		echo "cached"
		return
	fi
	echo "downloading"
	curl --silent -L -o "$target" "$url"	
}

cached-path() {
	echo "$__DOTS_INSTALL_TMP/$1"
}

mkdir -p "$__DOTS_DIR/install/build/.local/share/fonts"
download-cached "IosevkaTerm.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/IosevkaTerm.tar.xz"
tar -xf "$(cached-path "IosevkaTerm.tar.xz")" -C "$__DOTS_DIR/install/build/.local/share/fonts"


