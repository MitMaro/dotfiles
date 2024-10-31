download-with-cache "filen_x86_64.AppImage" "https://cdn.filen.io/desktop/release/filen_x86_64.AppImage"
cp "$(cached-path "filen_x86_64.AppImage")" "$__DOTS_DIR/build/.local/bin"
chmod +x "$__DOTS_DIR/build/.local/bin/filen_x86_64.AppImage"
template-replace "$__DOTS_DIR/build/.config/autostart/filen.desktop"
