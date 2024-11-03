
verify-command() {
	if ! command -v "$1" > /dev/null; then
		>&2 echo "Command \`$1\` not found, aborting"
		exit 1
	fi
}

install-packages() {
	while (($#)); do
		if ! dpkg-query -s "$1" &> /dev/null; then
				sudo apt install -y "$1"
		fi
		shift
	done
}

install-flatpak() {
	local remote="$1"
	shift
	while (($#)); do
		flatpak install -y --noninteractive "$remote" "$1"
		shift
	done
}

install-deb() {
	local name="$1"
	local url="$2"

	if ! dpkg-query -s "$1" &> /dev/null; then
		download-with-cache "$name.deb" "$url"
		DEBIAN_FRONTEND="noninteractive" sudo --non-interactive dpkg -i "$(cached-path "$name.deb")"
	fi
}

clone-and-update-repo() {
	local repo="$1"
	local ref="dep/$2"
	local name="$3"
	local target="$__DOTS_INSTALL_TMP/$3"
	local destination="${__DOTS_DIR}/build/$4"

	# clone repo if not setup, else pull
	if [ "$(git config --file "$target/.git/config" --get remote.dep.url)" != "$repo" ]; then
		git clone --origin dep "$repo" "$target"
	else
		git -C "$target" fetch dep
	fi

	if [ ! -z "$(git -C "$target" status --porcelain)" ]; then
		>&2 echo "The dependency '$target' is dirty, skipping reset to '$ref'"
	else
		git -C "$target" reset --hard "$ref"
  fi

	mkdir -p "$(dirname "$destination")"
  cp -r "$target" "$destination"
}

download-with-cache() {
	local target="$__DOTS_INSTALL_TMP/$1"
	local url="$2"

	if [ -e "$target" ]; then
		return
	fi
	curl --silent -L -o "$target" "$url"
}

cached-path() {
	echo "$__DOTS_INSTALL_TMP/$1"
}

copy-cached() {
	local name="$1"
	local destination="$2"

	mkdir -p "$destination"
  cp -r "$(cached-path "$name")" "$destination"
}


source-directory() {
	local subdirectory="$1"

	for f in "${__DOTS_DIR}/${subdirectory}/"*.{zsh,sh}; do
		if [[ -e "${f}" ]]; then
			source "${f}"
		fi
	done
}

template-replace() {
	local file="$1"
	sed -i "s|<HOME>|$HOME|g" "$file"
}

install-gpg-key-from-asc() {
	local name="$1"
	local url="$2"
	local keyring_path="/usr/share/keyrings/$name-keyring.gpg"

	if [[ ! -f "$keyring_path" ]]; then
		download-with-cache "$name.asc" "$url"
		sudo gpg --dearmor --output "$keyring_path" < "$(cached-path "$name.asc")"
	fi
}

install-gpg-key() {
	local name="$1"
	local url="$2"
	local keyring_path="/usr/share/keyrings/$name-keyring.gpg"

	if [[ ! -f "$keyring_path" ]]; then
		download-with-cache "$name.gpg" "$url"
		sudo cp "$(cached-path "$name.gpg")" "$keyring_path"
	fi
}

install-apt-source() {
	local name="$1"
	local src="$2"

	echo "$src" | sudo tee "/etc/apt/sources.list.d/$name.list"
}

