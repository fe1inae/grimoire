#!/bin/sh -eu

. lib/misc.sh

create_commitlist() {
	repo="${1}.git"
	cd "${GIT_ROOT}/${repo}"
	[ -f "git-daemon-export-ok" ] || return
	name="${1}"

	printf '20 text/gemini\r\n'
	printf '# %s\n' "$name commits"
	printf '\n'

	if [ "$#" = "2" ]; then
    	commit="${2}..HEAD"
    	printf 'after %s\n' "$2"
    else
    	commit="HEAD"
    fi

	printf '## commits\n\n'
	printf '=> HEAD/ HEAD\n'
	git log "${commit}" --format="%h %cs %s" | while read -r hash date desc; do
		printf '=> %s/ %s %s\n' "$hash" "$date" "$desc" \
			| sed -E 's/(.{76}).{3}.*/\1.../g'
	done
	printf '\n'
}


