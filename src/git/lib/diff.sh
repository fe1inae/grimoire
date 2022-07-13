#!/bin/sh -eu

. lib/misc.sh

cat_file() {
	if [ $# -lt 2 ]; then
		git cat-file --textconv "HEAD:${1}" 2>/dev/null
	else
		git cat-file --textconv "${1}:${2}" 2>/dev/null
	fi
}

create_diff() {
	name="${1}"
	repo="${1}.git"
	hash1="${2}"
	hash2="${3}"
	cd "${GIT_ROOT}/${repo}"
	[ -f "git-daemon-export-ok" ] || return
	echo "$@" > /dev/stderr

	printf '20 text/gemini\r\n'
	printf '# %s diff\n' "$name"
	printf '```\n'
	git diff "${hash1}^...${hash2}" | fold -w 79
	printf '```\n'
}
