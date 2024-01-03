#!/usr/bin/env bash

set -euo pipefail

export __DOTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"

source "${__DOTS_DIR}/scripts/install/common.sh"

os="$(uname | tr '[:upper:]' '[:lower:]')"
export __DOTS_OS="$os"

source "${__DOTS_DIR}/scripts/install/$os/pre-install.sh"
source "${__DOTS_DIR}/scripts/install/pre-install.sh"

source "${__DOTS_DIR}/scripts/install/build.sh"
source "${__DOTS_DIR}/scripts/install/$os/build.sh"

source "${__DOTS_DIR}/scripts/install/install.sh"
source "${__DOTS_DIR}/scripts/install/$os/install.sh"

echo "Install complete"
