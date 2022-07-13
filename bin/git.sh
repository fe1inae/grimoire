#!/bin/sh
# XXX: migrate to stagit-gemini
set -eu

GIT="${1}"
OUT="${2}"

mkdir -p "${2}"

repos="$(find "$GIT" -name git-daemon-export-ok | while read -r line; do
	printf '%s ' "${line%/*}"
done)"

# build index
for r in ${repos}; do
	name="${r}"
	name="${name#"${GIT}/"}"
	printf '=> git://ulthar.cat/%s %s - %s\n' \
		"$name" \
		"$(cd "${r}" && git log -1 --pretty=%as)" \
		"$(cd "${r}" && cat description )"
done > "${2}/index.gmi"
