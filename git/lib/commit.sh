#!/bin/sh -eu

. lib/misc.sh

cat_file() {
	if [ $# -lt 2 ]; then
		git cat-file --textconv "HEAD:${1}" 2>/dev/null
	else
		git cat-file --textconv "${1}:${2}" 2>/dev/null
	fi
}

create_commit() {
	repo="${1}.git"
	cd "${GIT_ROOT}/${repo}"
	[ -f "git-daemon-export-ok" ] || continue
	hash_s="$2"
	name="$1"

	printf '20 text/gemini\r\n'
	printf '# %s @ %s\n' "$name" "$hash_s"
	printf '\n'

	printf '## readme\n\n'
	printf '```\n'
	cat_file    "$hash_s" "README.gmi" \
	|| cat_file "$hash_s" "README"     \
	|| cat_file "$hash_s" "README.txt" \
	|| cat_file "$hash_s" "README.md"  \
	|| printf 'nil\n'
	printf '```\n'
	printf '\n'

	printf '## files\n\n'
	git ls-files --with-tree "$hash_s" | while read -r line; do
		printf '=> f/%s\n' "$line"
	done
	printf '\n'
}
