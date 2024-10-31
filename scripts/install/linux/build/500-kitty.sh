# Kitty install and setup
download-with-cache "kitty.txz" "https://github.com/kovidgoyal/kitty/releases/download/v0.36.4/kitty-0.36.4-x86_64.txz"
mkdir -p "$__DOTS_DIR/build/.local/kitty.app"
tar -xf "$(cached-path "kitty.txz")" -C "$__DOTS_DIR/build/.local/kitty.app"

template-replace "$__DOTS_DIR/build/.local/share/applications/kitty.desktop"
template-replace "$__DOTS_DIR/build/.local/share/applications/kitty-open.desktop"
