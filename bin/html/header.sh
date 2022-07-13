#!/bin/sh
set -eu

f="$(
	printf '%s\n' "$1" \
	| sed 's/\.md/.html/' \
	| sed 's;tmp/;;'
)"

printf '<table class="header">'
printf '<tr>'
printf '<th>'
IFS='/'
set -- ${f}
printf '/<a href="/">www</a>'
for i in "${@}"; do
	stack="${stack:-""}/${i}"
	printf '/<a href="%s">%s</a>' "$stack" "$i"
done
printf '</th>'
printf '<th>'
printf 'made for <a href="/etc/smolnet.html">smolnet</a>'
printf '</th>'
printf '</tr>'
printf '</table>'
