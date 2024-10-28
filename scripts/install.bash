#!/usr/bin/env bash

set -euo pipefail

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

source "${__DOTS_DIR}/scripts/install/install.sh"
source "${__DOTS_DIR}/scripts/install/$os/install.sh"

source "${__DOTS_DIR}/scripts/install/post-install.sh"
source "${__DOTS_DIR}/scripts/install/$os/post-install.sh"

rm -rf "${__DOTS_INSTALL_TMP}"

echo "Install complete"
