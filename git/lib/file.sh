#!/bin/sh -eu

. lib/misc.sh

cat_file() {
	if [ $# -lt 2 ]; then
		git cat-file --textconv "HEAD:${1}"
	else
		git cat-file --textconv "${1}:${2}"
	fi
}


create_file() {
	name="${1}"
	repo="${1}.git"
	path="${2}"
	cd "${GIT_ROOT}/${repo}"
	[ -f "git-daemon-export-ok" ] || continue

	printf '20 text/gemini\r\n'
	printf '# %s/%s\n\n' "$name" "$path"
	printf '```\n'

	cat_file "$path" | awk -e '
	BEGIN { N=1 }
	{
		print sprintf("% 4d] %s", N, $0)
		N++
	}
	'
	printf '```\n'

}


