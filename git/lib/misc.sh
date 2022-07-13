split() {
    # disable globbing
	set -f
	# store old ifs
	OLDIFS=$IFS
	# set ifs to arg
	IFS=$2
	# we want this to split
	# shellcheck disable=2086
	set -- $1
	# print each
	printf '%s\n' "$@"
	# restore IFS
	IFS=$OLDIFS
	# restore globbing
	set +f
}

