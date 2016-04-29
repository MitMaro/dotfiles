
if hash underscore 2>/dev/null; then
	alias json="underscore print --outfmt pretty --color"
else
	alias json="python -m json.tool"
fi
