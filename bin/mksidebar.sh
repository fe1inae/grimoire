#!/bin/sh
set -eu

#shellcheck disable=SC2254
match() {
	case "${1}" in
	${2}) return 0 ;;
	*) return 1 ;;
	esac
}

printf '<div class="sidebar">'
printf '
<a href="/">
<img src="/fel.png" alt="home" style="width:18ch">
</a><br>
'
mklink() {
	printf '<a href="%s">%s</a><br>' "${1}" "${2}"
}

outname() {
	oname="${1#tmp/}"
	oname="${1#./tmp/}"
	oname="${WWW}/${oname}"
	case "${oname}" in
	*.mdoc) printf '%s.html\n' "${oname%.*}" ;;
	*.sh) printf '%s\n' "${oname%.*}" ;;
	*) printf '%s\n' "${oname}" ;;
	esac
}

WWW=tmp

idir="${1%/*}"

stack="."
IFS='/'
for e in ${idir}; do
	stack="${stack}/${e}"
	for f in "${stack}"/*; do
		#shellcheck disable=SC2310
		if [ -d "${f}" ] \
			|| match "${f##*.}" "*mdoc*" \
			&& ! match "${f}" "*index*" \
			; then
			outname "${f}"
		fi
	done
done | sort | while read -r line; do
	line="${line#"${WWW}"}"
	name="${line#/}"
	name="${name%.html}"
	case "${1}" in
	*"${name}"[/.]*)
		mklink "${line}" \
			"<b>$(printf '%s' "${name}" | sed -E 's|[^/]+/|——|g')</b>"
		;;
	*)
		mklink "${line}" "$(printf '%s' "${name}" | sed -E 's|[^/]+/|··|g')"
		;;
	esac
done
printf '</div>'
