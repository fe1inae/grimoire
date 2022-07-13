#!/bin/sh
. bin/lib.sh

mkdir -p tmp/gmni/git

notify "GENERATING REPOS"
repos="$(
	find "${REPODIR}" -name "git-daemon-export-ok" | while IFS= read -r d; do
		d="${d%/*}"
		name="${d#"${REPODIR}"/}"
		name="${name%.git}"
		mkdir -p "tmp/gmni/git/${name}"
		(
			cd "tmp/gmni/git/${name}" || return
			if [ "$(cd "${d}" && git log -1 --pretty=%ct)" \
				-lt \
				"$(stat -c %Y index.gmi 2> /dev/null)" \
				] 2> /dev/null && [ "${FORCE}" = 0 ]; then
				lskip "."
			else
				lmake "."
				#shellcheck disable=SC2016
				printf '# %s\n=> %s\n\n```\n%s\n```\n' \
					"${name}" \
					"$(cat "${d}/url")" \
					"$(cd "${d}" && (
						git cat-file blob HEAD:README \
							|| git cat-file blob HEAD:README.gmi \
							|| git cat-file blob HEAD:README.md \
							|| git cat-file blob HEAD:.README \
							|| git cat-file blob HEAD:.README.gmi \
							|| git cat-file blob HEAD:.README.md
					) 2> /dev/null)" \
					> "index.gmi"
			fi
		)
		printf '%s ' "${d}"
	done
)"

(
	printf '# repositories
=> https://ulthar.cat/git/ semi-interactive http interface
\n'
	for d in ${repos}; do
		name="${d#"${REPODIR}"/}"
		name="${name%.git}"
		printf '%s	%s	%s\n' \
			"$(cd "${d}" && git log -1 --pretty=%ct)" \
			"${name}" \
			"$(cat "${d}/description")"
	done | sort -nr | while read -r line; do
		IFS="	"
		# shellcheck disable=SC2086
		set -- ${line}
		printf '=> %s/\n%s - %s\n\n' \
			"${2}" \
			"$(date -d "@${1}" "+%Y-%m-%d")" \
			"${3}"
	done
) > tmp/gmni/git/index.gmi
