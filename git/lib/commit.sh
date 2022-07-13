#!/bin/sh -eu

. lib/misc.sh

cat_file() {
	if [ $# -lt 2 ]; then
		git cat-file --textconv "HEAD:${1}" 2>/dev/null
	else
		git cat-file --textconv "${1}:${2}" 2>/dev/null
	fi
}

readmes="
readme
.readme
README
README.md
"

create_commit() {
	repo="${1}.git"
	cd "${GIT_ROOT}/${repo}"
	[ -f "git-daemon-export-ok" ] || return
	hash_s="$2"
	name="$1"

	printf '20 text/gemini\r\n'
	printf '# %s @ %s\n' "$name" "$hash_s"
	printf '\n'

	printf '=> d/ diff\n'

	printf '## readme\n\n'
	for f in $readmes; do
    	cat_file "$f" && break
    done
	printf '\n'

	printf '## files\n\n'
	git ls-files --with-tree "$hash_s" | while read -r line; do
		printf '=> f/%s\n' "$line" \
			| sed -E 's/(.{76}).{3}.*/\1.../g'
	done
	printf '\n'
}
