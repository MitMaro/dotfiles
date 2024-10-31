download-with-cache "rustup-init" "https://sh.rustup.rs"

sh "$(cached-path "rustup-init")" -y
