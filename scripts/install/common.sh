
verify-command() {
	if ! command -v "$1" > /dev/null; then
		>&2 echo "Command \`$1\` not found, aborting"
		exit 1
	fi
}

install-packages() {
	while (($#)); do
			if ! dpkg-query -s "$1" &> /dev/null; then
					apt install -y "$1"
			fi
			shift
	done
}

clone-and-update-repo() {
	local repo="$1"
	local ref="dep/$2"
	local destination="${__DOTS_DIR}/$3"
	mkdir -p "$destination"
	# clone repo if not setup, else pull
	if [ "$(git config --file "$destination/.git/config" --get remote.dep.url)" != "$repo" ]; then
		git clone --origin dep "$repo" "$destination"
	else
		git -C "$destination" fetch dep
	fi
	if [ ! -z "$(git -C "$destination" status --porcelain)" ]; then
		>&2 echo "The dependency '$destination' is dirty, skipping reset to '$ref'"
	else
		git -C "$destination" reset --hard "$ref"
  fi
}
