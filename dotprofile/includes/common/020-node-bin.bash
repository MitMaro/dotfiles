
add-node-bin() {
	echo $PATH | grep './node_modules/.bin' >/dev/null 2>&1 
	if [[ $? -ne 0 ]]; then
		echo "Adding node_modules/.bin/ to PATH"
		export PATH=$PATH:'./node_modules/.bin'
	else
		echo "node_modules/.bin/ already in PATH"
	fi
}
