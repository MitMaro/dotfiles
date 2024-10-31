echo "Loading gsettings"
python3 -m venv "${__DOTS_DIR}/.venv"
"${__DOTS_DIR}/.venv/bin/pip3" install -r "${__DOTS_DIR}/requirements.txt"
source "${__DOTS_DIR}/.venv/bin/activate"
"$__DOTS_DIR/scripts/load-gsettings.py" "$__DOTS_DIR/settings/"
deactivate
