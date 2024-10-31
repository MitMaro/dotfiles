mkdir -p "$__DOTS_DIR/build/.local/share/fonts"
download-with-cache "IosevkaTerm.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/IosevkaTerm.tar.xz"
tar -xf "$(cached-path "IosevkaTerm.tar.xz")" -C "$__DOTS_DIR/build/.local/share/fonts"
