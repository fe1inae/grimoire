#!/bin/sh
set -eu

GIT="$HOME/git"

repos="$(find "$GIT" -name git-daemon-export-ok | while read -r line; do
	printf '%s ' "${line%/*}"
done)"

printf '# repos\ngit clone ...\n\n'

# build index
for r in ${repos}; do
	name="${r}"
	name="${name#"${GIT}/"}"
	printf '=> git://ulthar.cat/%s %s @ %s : %s\n' \
		"${name}" \
		"$(cd "${r}" && git log -1 --pretty=%as)" \
		"${name%.git}" \
		"$(cd "${r}" && cat description )"
done | sort -nr
