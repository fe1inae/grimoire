#!/bin/sh -eux

. lib/misc.sh

create_index() {
	printf '20 text/gemini\r\n'
    printf '# fels repos\n'

    for repo in "$GIT_ROOT"/*; do
        cd "${repo}"
        [ -f "git-daemon-export-ok" ] || continue

        name="${repo%%.git}"
        name="${name##*/}"

        if [ -f "archive" ]; then
            date="ARCHIVED"
        else
	        date="$(git log -1 --format=%cs | tr -d '-')"
        fi

        printf '%s|%s|%s\n' "$date" "$name" \
        					"$(cat "${repo}/description")"
    done | sort -nr | awk -F'|' -e '
    {
        print "\n=> " $2 "/"
        print $1 " - " $3
    }
    '
}
