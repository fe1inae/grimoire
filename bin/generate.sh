# generates list of targets for gemini, html, etc.
# piped to Makefile.in from the makefile.

printf 'SRC='
find src | while read -r file; do
	[ -f "$file" ] || continue
	name="${file}"
	name="${name#*/}"
	name="${name%.*}"
	ext="${file##*.}"
	for i in gmi html; do
		case "$file" in
			*.gmi.sh) printf 'build/%s/%s.%s'  "$i" "${name%.gmi}" "$i" ;;
			*.gmi)    printf 'build/%s/%s.%s'  "$i" "$name" "$i"        ;;
			*.sh)     printf 'build/%s/%s'     "$i" "$name"             ;;
			*)        printf 'build/%s/%s.%s'  "$i" "$name" "$ext"      ;;
		esac
		printf ' '
	done
done
printf '\n'
