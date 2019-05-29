
if type lsd &> /dev/null; then
	alias ls='lsd -l'
else
	alias ls='ls -l --color=auto'
fi
