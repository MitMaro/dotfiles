
if type lsd &> /dev/null; then
	alias ls='lsd -la'
else
	alias ls='ls -la --color=auto'
fi
