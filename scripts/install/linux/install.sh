#!/usr/bin/env bash

echo "Loading gsettings"
python3 -m venv "${__DOTS_DIR}/.venv"
"${__DOTS_DIR}/.venv/bin/pip3" install -r "${__DOTS_DIR}/requirements.txt"
source "${__DOTS_DIR}/.venv/bin/activate"
"$__DOTS_DIR/scripts/load-gsettings.py" "$__DOTS_DIR/settings/"
deactivate

download-with-cache "git-delta.deb" "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb"
DEBIAN_FRONTEND="noninteractive" sudo --non-interactive dpkg -i "$(cached-path "git-delta.deb")"

install-packages zsh vim

if [[ "$SHELL" != "/bin/zsh" ]]; then
	echo "Updating shell to zsh"
	chsh -s "/bin/zsh"
	echo "You will need to logout and login again for the SHELL change to take effect"
fi

echo "If new gnome extensions were installed, you will need to restart gnome with the \`r\` command."
