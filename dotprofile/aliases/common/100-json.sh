
if type jq &> /dev/null; then
	alias json="jq '.'"
else
	alias json="python -m json.tool"
fi
