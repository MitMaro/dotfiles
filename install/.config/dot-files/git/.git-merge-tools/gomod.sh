#!/usr/bin/env bash

# Based on https://gist.github.com/joelrebel/8f73986cb2ec0fb02868e525b1f464c1

set -euo pipefail

function clear_markers() {
	file_with_markers="$1"
	if [[ -f "$file_with_markers" ]]; then
		>&2 echo "Purging conflict markers: $file_with_markers"
		awk '!/======/' "$file_with_markers" | awk '!/>>>>>>/' | awk '!/<<<<<<</' | awk '!/\|\|\|\|\|\|\|/' > "${file_with_markers}_union"
		mv "${file_with_markers}_union" "$file_with_markers"
	fi
}

root_dir="$(dirname "$4")"
if [[ "$(basename "$root_dir")" == "vendor" ]]; then
	root_dir="$(dirname "$root_dir")"
fi

clear_markers "$root_dir/go.mod"
clear_markers "$root_dir/go.sum"
clear_markers "$root_dir/vendor/modules.txt"

pushd "$root_dir"
>&2 echo "Cleaning up Go modules in $root_dir"
go mod tidy
go mod vendor
popd "$root_dir"
