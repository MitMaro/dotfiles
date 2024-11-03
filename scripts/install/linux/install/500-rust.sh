if ! command -v "rustup" > /dev/null; then
	download-with-cache "rustup-init" "https://sh.rustup.rs"

	sh "$(cached-path "rustup-init")" -y
fi
