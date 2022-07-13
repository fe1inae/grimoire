#!/bin/sh
set -eu

f="$(printf '%s\n' "$1" | sed 's/\.gmi/.html/')"

printf '<table class="header">'
printf '<tr>'
printf '<th>'
IFS='/'
set -- ${f}
printf '/<a href="/">root</a>'
for i in "${@}"; do
	stack="${stack:-""}/${i}"
	printf '/<a href="%s">%s</a>' "$stack" "$i"
done
printf '</th>'
printf '<th>'
printf 'made for <a href="https://gemini.circumlunar.space/">gemini</a>'
printf '</th>'
printf '</tr>'
printf '</table>'
