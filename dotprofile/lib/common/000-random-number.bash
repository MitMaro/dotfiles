
random_number() {
	local min=${1:-0}
	local max=${2:-32767}
	
	# See if the min and max are reversed, if so reverse
	if [ ${min} -gt ${max} ]; then
		local x=${min}
		min=${max}
		max=${x}
	fi
	RAND=$((RANDOM%max+min))
}
