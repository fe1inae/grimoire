WWW="${PUBLIC}/www/gmi"

find src | while read -r file; do
	[ -f "$file" ] || continue
	out="${WWW}/${file#src/}"
	ext="${out##*.}"
	out="${out%."${ext}"}"
	mkdir -p "${out%/*}"

	case "${ext}" in
	ft)
		sed 's;\.ext;.gmi;g' "$file" \
		| awk -f bin/ft2gmi.awk      \
		| fold -s -w 80              \
		> "${out}.gmi"
		;;
	sh) sh "$file" > "${out}" ;;
	*) cp "$file" "${out}.${ext}" ;;
	esac
done
