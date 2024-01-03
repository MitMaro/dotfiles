function get-project-root() {
	local project_file
	case "${1-""}" in
		'node')
			project_file='package.json' ;;
		'rust')
			project_file='Cargo.toml' ;;
		'go')
			project_file='go.mod' ;;
		*)
			return 1 ;;
	esac

	# traverse parents until project root is found
	project_root=
	current_path="$PWD"
	while [[ "$current_path" != "/" ]]; do
		if [[ -f "$current_path/$project_file" ]]; then
			project_root="$current_path"
			break;
		else
			current_path="$(dirname "$current_path")"
		fi
	done
	if [[ -z "$project_root" ]]; then
		return 1
	fi
	printf "%s" "$project_root"
	return 0
}
