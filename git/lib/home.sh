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

create_home() {
	repo="${1}.git"
	cd "${GIT_ROOT}/${repo}"
	[ -f "git-daemon-export-ok" ] || return
	name="${1}"
	shift

	printf '20 text/gemini\r\n'
	printf '# %s\n' "$name"
	printf '=> git://ulthar.cat/%s\n' "$repo"
	printf '\n'

	printf '## readme\n\n'
	for f in $readmes; do
    	cat_file "$f" && break
    done
	printf '\n'

	printf '## files\n\n'
	git ls-files --with-tree HEAD | while read -r line; do
		printf '=> f/%s\n' "$line" \
			| sed -E 's/(.{76}).{3}.*/\1.../g'
	done | head -n 20
	printf '=> f/ ...\n'
	printf '\n'

	printf '## commits\n\n'
	git log -10 --format="%h %cs %s" | while read -r hash date desc; do
		printf '=> c/%s/ %s %s\n' "$hash" "$date" "$desc" \
			| sed -E 's/(.{76}).{3}.*/\1.../g'
	done
	printf '=> c/       ...\n'
	printf '\n'
}

