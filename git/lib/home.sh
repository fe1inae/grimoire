#!/bin/sh -eu

. lib/misc.sh

cat_file() {
	if [ $# -lt 2 ]; then
		git cat-file --textconv "HEAD:${1}" 2>/dev/null
	else
		git cat-file --textconv "${1}:${2}" 2>/dev/null
	fi
}

create_home() {
	repo="${1}.git"
	cd "${GIT_ROOT}/${repo}"
	[ -f "git-daemon-export-ok" ] || continue
	name="${1}"
	shift

	printf '20 text/gemini\r\n'
	printf '# %s\n' "$name"
	printf '\n'

	printf '## readme\n\n'
	printf '```\n'
	cat_file    "README.gmi" \
	|| cat_file "README"     \
	|| cat_file "README.txt" \
	|| cat_file "README.md" \
	|| printf 'nil\n'
	printf '```\n'
	printf '\n'

	printf '## files\n\n'
	git ls-files --with-tree HEAD | while read -r line; do
		printf '=> f/%s\n' "$line"
	done
	printf '\n'

	printf '## commits\n\n'
	git log -5 --format="%h %cs %s" | while read -r hash date desc; do
		printf '=> c/%s/ %s %s\n' "$hash" "$date" "$desc"
	done
	printf '=> c/       ...\n'
	printf '\n'
}

