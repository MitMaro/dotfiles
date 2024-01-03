#!/usr/bin/env bash

[ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

verify-command "brew"

brew bundle --no-upgrade --file=- <<-EOS
brew "stow"
EOS
