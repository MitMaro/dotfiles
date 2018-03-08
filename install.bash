#!/usr/bin/env bash

export __DOTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${__DOTS_DIR}/osx/defaults.bash"

#exit

EXIT_ERROR_UNKNOWN_ARGUMENT=1
EXIT_ERROR_INVALID_ARGUMENT=2
EXIT_ERROR_INVALID_STATE=3

# only enable colors when supported
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# Color Constants
	C_RESET="\033[0m" # normal color
	C_LOG_DATE="\033[0;36m"
	C_DRY_RUN_COMMAND="\033[1;35m"
	C_HIGHLIGHT="\033[1;34m"
	C_WARNING="\033[1;33m"
	C_ERROR="\033[0;31m"
	C_STATUS="\033[1m"
else
	C_RESET=''
	C_LOG_DATE=''
	C_HIGHLIGHT=''
	C_ERROR=''
	C_WARNING=''
	C_DRY_RUN_COMMAND=''
	C_STATUS=''
fi

self=`basename "$0"`
root=$(realpath $(dirname "${BASH_SOURCE[0]}"))
is_dry_run=false
dry_run=
target_dir="$HOME"
target_dir=/tmp/"$HOME"
verbose=
linked_file_conflict=false
backup_postfix="-backup-$(date +%s)"

usage() {
	echo "usage: $self [options]"
	echo
	echo "--dry-run           Don't perform any action but print operations"
	echo "--help              Show this usage message"
	echo "--prefix=<path>"
	echo "--prefix <path>     Set the install taget directory"
}

message() {
	message=$(date '+%Y/%m/%d %H:%M:%S')
	message="[${C_LOG_DATE}${message}${C_RESET}] ${@}"
	echo -e ${message}
}

info_message() {
	message "   [INFO] ${@}"
}

verbose_message() {
	if ${verbose}; then
		message "[VERBOSE] ${@}"
	fi
}

warning() {
	message "${C_WARNING}[WARNING]${C_RESET} ${@}"
}

error() {
	>&2 message "${C_ERROR}  [ERROR]${C_RESET}${1}"

	if [[ ${3} ]]; then
		>&2 usage
	fi

	if [[ ! -z ${2} ]]; then
		exit $2
	fi
}

highlight() {
	echo "${C_HIGHLIGHT}${@}${C_RESET}"
}

dry_run_message() {
	message "${C_DRY_RUN_COMMAND}[DRY RUN]${C_RESET}${@}"
}

add_link() {
	link_path="$1"
	link_name="$2"

	if [[ -h "${link_name}" ]]; then
		existing_link_target=$(realpath "${link_name}")
		if [[ "$existing_link_target" == "$link_path" ]]; then
			info "${link_name} was already linked to the correct file"
			return
		else
			error "$(highlight ${link_name}) was already linked, but to a different location and will be skipped"
			linked_file_conflict=true
		fi
	elif [[ -e "${link_name}" ]]; then
		verbose_message "${link_name} already exists, creating backup"
		${dry_run} mv "${link_name}" "${link_name}${backup_postfix}"
	fi

	verbose_message "Linking ${link_name} already exists, creating backup"
	${dry_run} ln -s "${link_path}" "${link_name}"
}

# check for -- at beginning of value
check_argument_skipped () {
	if [[ "$2" == --* ]]; then
		>&2 echo "Invalid argument value passed for $1: $2 "
		>&2 usage
		exit $EXIT_ERROR_INVALID_ARGUMENT
	fi
	echo "$2"
}

# defaults


while (($#)); do
	case "$1" in
		--dry-run)
			verbose=true
			is_dry_run=true;
			dry_run=dry_run_message;
			;;
		-v|--verbose)
			verbose=true
			;;
		--prefix=*)
			target_dir="${1#--prefix=}"
			;;
		--prefix)
			target_dir=$(check_argument_skipped "$1" "$2")
			shift
			;;
		--help)
			usage
			exit 0
			;;
		--)
			# skip this
			;;
		*)
			>&2 echo "Unexpected argument: $1"
			>&2 usage
			exit $EXIT_ERROR_UNKNOWN_ARGUMENT
			;;
	esac
	shift
done

if [ -z "$target_dir" ]; then
	>&2 echo "The target directory prefix cannot be empty"
	exit $EXIT_ERROR_INVALID_ARGUMENT
fi

if [[ "$target_dir" == "/" ]]; then
	>&2 echo "Refusing to install to root directory"
	exit $EXIT_ERROR_INVALID_ARGUMENT
fi

if [[ ! -d "$target_dir" ]]; then
	>&2 echo "$target_dir does not a valid directory"
	exit $EXIT_ERROR_INVALID_ARGUMENT
fi

if [[ ! -w "$target_dir" ]]; then
	>&2 echo "$target_dir is not writable"
	exit $EXIT_ERROR_INVALID_ARGUMENT
fi

# make sure we are in the right directory
cd $(dirname "${BASH_SOURCE[0]}")

for file in $link_files; do
	IFS=':' read -a parts <<< "$file"

	if [[ -z ${parts[1]} ]]; then
		>&2 echo "Invalid symlink mapping: $file"
		exit $EXIT_ERROR_INVALID_STATE
	fi

	if [[

done

