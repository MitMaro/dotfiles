if [[ ! -f ~/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox ]]; then
	download-with-cache "jetbrains-toolbox.tar.gz" "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"

	tar -xf "$(cached-path "jetbrains-toolbox.tar.gz")" -C "$__DOTS_INSTALL_TMP"

	"$__DOTS_INSTALL_TMP/jetbrains-toolbox-"*"/jetbrains-toolbox"
fi
