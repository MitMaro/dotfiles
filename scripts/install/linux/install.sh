#!/usr/bin/env bash

echo "Loading gsettings"
python3 -m venv "${__DOTS_DIR}/.venv"
pip3 install -r "${__DOTS_DIR}/requirements.txt"
source "${__DOTS_DIR}/.venv/bin/activate"
"$__DOTS_DIR/scripts/load-gsettings.py" "$__DOTS_DIR/settings/"
deactivate

sudo --validate
curl --silent -L -o "$__DOTS_INSTALL_TMP/git-delta.deb" "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb"
DEBIAN_FRONTEND="noninteractive" sudo --non-interactive dpkg -i "$__DOTS_INSTALL_TMP/git-delta.deb"

if [[ "$SHELL" != "/bin/zsh" ]]; then
	echo "Updating shell to zsh"
	chsh -s "/bin/zsh"
	echo "You will need to logout and login again for the SHELL change to take effect"
fi

echo "If new gnome extensions were installed, you will need to restart gnome with the \`r\` command."
