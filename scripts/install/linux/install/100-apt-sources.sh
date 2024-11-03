# 1Password
install-gpg-key-from-asc "1password" "https://downloads.1password.com/linux/keys/1password.asc"
install-apt-source "1password" \
 	'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main'
if [[ ! -d "/etc/debsig/policies/AC2D62742012EA22/" ]]; then
	sudo mkdir -p "/etc/debsig/policies/AC2D62742012EA22/"
	download-with-cache "1password.pol" "https://downloads.1password.com/linux/debian/debsig/1password.pol"
	sudo cp "$(cached-path "1password.pol")" "/etc/debsig/policies/AC2D62742012EA22/1password.pol"
fi
if [[ ! -d "/usr/share/debsig/keyrings/AC2D62742012EA22/" ]]; then
	sudo mkdir -p "/usr/share/debsig/keyrings/AC2D62742012EA22/"
	download-with-cache "1password.asc" "https://downloads.1password.com/linux/keys/1password.asc"
	sudo gpg --dearmor --output "/usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg" < "$(cached-path "1password.asc")"
fi

sudo apt update


