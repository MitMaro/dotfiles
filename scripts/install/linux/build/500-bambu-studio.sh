if [[ ! -f ~/.local/bin/BambuStudio.AppImage ]]; then
	download-with-cache "BambuStudio.AppImage" "https://github.com/bambulab/BambuStudio/releases/download/v01.09.07.52/Bambu_Studio_ubuntu-v01.09.07.52-24.04.AppImage"
	cp "$(cached-path "BambuStudio.AppImage")" "$__DOTS_DIR/build/.local/bin"
	chmod +x "$__DOTS_DIR/build/.local/bin/BambuStudio.AppImage"
fi
template-replace "$__DOTS_DIR/build/.local/share/applications/bambu-studio.desktop"
