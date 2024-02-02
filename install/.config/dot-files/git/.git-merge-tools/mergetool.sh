#!/usr/bin/env bash

# This file should not be needed, since Git should be able to switch between mergetool based on gitattributes
# However, after trying for several hours, I could not get it to work in a way I like

set -euo pipefail

file_merge="$4" ## The file containing the conflict markers

GO_MERGE_TOOL="$HOME/.config/dot-files/git/.git-merge-tools/gomod.sh"
mergetool=vimdiff

case "$file_merge" in
	**/go.mod)
		mergetool="$GO_MERGE_TOOL"
		;;
	**/go.sum)
		mergetool="$GO_MERGE_TOOL"
		;;
	**/vendor/modules.txt)
		mergetool="$GO_MERGE_TOOL"
		;;
	*)
		>&2 echo "No merge tool available for $file_merge"
		exit 1
		;;
esac

$mergetool "${@}"
