#!/bin/bash

# Based on https://gist.github.com/joelrebel/8f73986cb2ec0fb02868e525b1f464c1

set -e
fileMerge=$4 ## The file containing the conflict markers

echo "$fileMerge: purging conflict markers.."
awk '!/======/' "$fileMerge" | awk '!/>>>>>>/' | awk '!/<<<<<<</' > "${fileMerge}_union"
mv "${fileMerge}_union" "${fileMerge}"

# TODO change to mod.go directory to run these
go mod tidy
go mod vendor
