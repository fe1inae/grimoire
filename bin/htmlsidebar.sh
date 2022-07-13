#!/bin/sh
set -eu

printf '<div class="header">'
target="/${1}"
IFS='/'
set -- ${@}
printf '/<a href="/">root</a>'
for i in "${@}"; do
	stack="${stack:-""}/${i}"
	printf '/<a href="%s">%s</a>' "$stack" "$i"
done
printf '</div>'
