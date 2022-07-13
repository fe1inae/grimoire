#!/bin/sh -eu

. lib/misc.sh

create_commitlist() {
	repo="${1}.git"
	cd "${GIT_ROOT}/${repo}"
	[ -f "git-daemon-export-ok" ] || continue
	name="${1}"
	shift

	printf '20 text/gemini\r\n'
	printf '# %s\n' "$name commits"
	printf '\n'

	printf '## commits\n\n'
	git log --format="%h %cs %s" | while read -r hash date desc; do
		printf '=> %s/ %s %s\n' "$hash" "$date" "$desc"
	done
	printf '\n'
}


