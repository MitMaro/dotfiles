#!/usr/bin/env bash

echo "Loading gsettings"
pipenv install  &> /dev/null
pipenv shell &> /dev/null
"$__DOTS_DIR/scripts/load-gsettings.py" "$__DOTS_DIR/settings/gsettings.json"

if [[ "$SHELL" != "/bin/zsh" ]]; then
	echo "Updating shell to zsh"
	chsh -s "/bin/zsh"
	echo "You will need to logout and login again for the SHELL change to take effect"
fi

echo "If new gnome extensions were installed, you will need to restart gnome with the \`r\` command."
