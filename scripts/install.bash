#!/usr/bin/env bash

set -euo pipefail

echo "Installation requires root access with sudo"
sudo --validate

export HOST="$(hostname)"

export __DOTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"

source "${__DOTS_DIR}/scripts/install/common.sh"

os="$(uname | tr '[:upper:]' '[:lower:]')"
export __DOTS_OS="$os"

export __DOTS_INSTALL_TMP="${__DOTS_DIR}/.dots-tmp" # temporary file/download cache

mkdir -p "${__DOTS_INSTALL_TMP}"

source "${__DOTS_DIR}/scripts/install/$os/pre-install.sh"
source "${__DOTS_DIR}/scripts/install/pre-install.sh"

source "${__DOTS_DIR}/scripts/install/build.sh"
source "${__DOTS_DIR}/scripts/install/$os/build.sh"

# only install secrets if 1Password CLI is logged in
if command -v "op" &>/dev/null && op whoami &>/dev/null; then
	source "${__DOTS_DIR}/scripts/install/build-secrets.sh"
	source "${__DOTS_DIR}/scripts/install/$os/build-secrets.sh"
else
	echo "##########################################################"
	echo "# 1Password not setup, some steps were skipped           #"
	echo "# Install the 1Password CLI and login using: 'op signin' #"
	echo "##########################################################"
fi

source "${__DOTS_DIR}/scripts/install/install.sh"
source "${__DOTS_DIR}/scripts/install/$os/install.sh"

source "${__DOTS_DIR}/scripts/install/post-install.sh"
source "${__DOTS_DIR}/scripts/install/$os/post-install.sh"

echo "Install complete"
