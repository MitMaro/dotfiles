
if [[ -d "/etc/profile.d" ]]; then
	for i in /etc/profile.d/*.sh; do
		if [[ -r "$i" ]]; then
			source "$i"
		fi
	done
	unset i
fi
