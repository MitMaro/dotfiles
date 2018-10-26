
# $? is 0 if contained, else 1
array_contains() {
	for e in "${@:2}"; do
		[[ "$e" = "$1" ]]  && break;
	done;
}
