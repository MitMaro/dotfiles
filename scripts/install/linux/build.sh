#!/usr/bin/env bash

#mkdir -p "$__DOTS_DIR/build/.config/terminator/plugins"
#mkdir -p "$__DOTS_DIR/build/.local/share/gnome-shell/extensions/"

mkdir -p "$__DOTS_DIR/install/build/.local/share/fonts"
curl --silent -L -o "$__DOTS_INSTALL_TMP/IosevkaTerm.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/IosevkaTerm.tar.xz"
tar -xf "$__DOTS_INSTALL_TMP/IosevkaTerm.tar.xz" -C "$__DOTS_DIR/install/build/.local/share/fonts"
