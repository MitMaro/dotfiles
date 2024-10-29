#!/usr/bin/env bash

mkdir -p "$__DOTS_DIR/build/.local/share/fonts"
download-with-cache "IosevkaTerm.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/IosevkaTerm.tar.xz"
tar -xf "$(cached-path "IosevkaTerm.tar.xz")" -C "$__DOTS_DIR/build/.local/share/fonts"

# Kitty install and setup
download-with-cache "kitty.txz" "https://github.com/kovidgoyal/kitty/releases/download/v0.36.4/kitty-0.36.4-x86_64.txz"
mkdir -p "$__DOTS_DIR/build/.local/kitty.app"
tar -xf "$(cached-path "kitty.txz")" -C "$__DOTS_DIR/build/.local/kitty.app"

mkdir -p "$__DOTS_DIR/build/.local/share/applications/"
cp "$__DOTS_DIR/build/.local/kitty.app/share/applications/kitty.desktop" "$__DOTS_DIR/build/.local/share/applications/"
cp "$__DOTS_DIR/build/.local/kitty.app/share/applications/kitty-open.desktop" "$__DOTS_DIR/build/.local/share/applications/"
sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "$__DOTS_DIR/build/.local/share/applications/"kitty*.desktop
sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" "$__DOTS_DIR/build/.local/share/applications/"kitty*.desktop
