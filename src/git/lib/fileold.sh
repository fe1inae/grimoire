#!/bin/sh -eu

. lib/misc.sh

cat_file() {
	if [ $# -lt 2 ]; then
		git cat-file --textconv "HEAD:${1}"
	else
		git cat-file --textconv "${1}:${2}"
	fi
}


create_fileold() {
	name="${1}"
	repo="${1}.git"
	hash="${2}"
	path="${3}"
	cd "${GIT_ROOT}/${repo}"
	[ -f "git-daemon-export-ok" ] || return

	printf '20 text/gemini\r\n'
	printf '# %s/%s @ %s\n\n' "$name" "$path" "$hash"
	printf '```\n'

	cat_file "$hash" "$path" | awk -e '
	BEGIN { N=1 }
	{
		print sprintf("% 4d] %s", N, $0)
		N++
	}
	'
	printf '```\n'

}


