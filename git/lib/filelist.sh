#!/bin/sh -eu

. lib/misc.sh

create_filelist() {
	repo="${1}.git"
	cd "${GIT_ROOT}/${repo}"
	[ -f "git-daemon-export-ok" ] || return
	name="${1}"
	shift

	printf '20 text/gemini\r\n'
	printf '# %s\n' "$name files"
	printf '\n'

	printf '## files\n\n'
	git ls-files --with-tree HEAD | while read -r line; do
		printf '=> %s\n' "$line" \
			| sed -E 's/(.{76}).{3}.*/\1.../g'
	done
	printf '\n'
}


