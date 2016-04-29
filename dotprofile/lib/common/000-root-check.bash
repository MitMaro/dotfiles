

__root_check() {

	forced=${1:0}

	if [[ $EUID -ne 0 ]]; then
		echo "This script must be run as root" 1>&2

		if [[ forced -ne 0 ]]; then
			kill -INT $$ # kinda like pressing ctrl-c
		fi
	fi
}
