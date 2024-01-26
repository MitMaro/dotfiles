if [[ -e "$HOME/.cargo/bin" ]]; then
	export PATH="$HOME/.cargo/bin:$PATH"
fi

# rustup
if [[ -e "$HOME/.cargo/env" ]]; then
	source "$HOME/.cargo/env"
fi
