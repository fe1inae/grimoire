cd "${0%/*}" || true

cat <<'EOF'
# posts
gemlog. expect rampant incoherency, so be warned :P

EOF

for f in *; do
	case "$f" in
	*.gmi)
		printf '%s %s %s\n' \
			"$(sed -n '/^[0-9]/ {s/^\([^ ]*\).*/\1/p; q'} "$f")" \
			"${f%.gmi}.ext" \
			"$(sed -n '/^#/ {s/^# \(.*\)/\1/p; q}' "$f")"
		;;
	esac
done | sort -nr | while read -r line; do
	set -- $line
	time="$1"
	url="$2"
	shift; shift
	desc="$@"
	printf '=> protocol://ulthar.cat/doc/%s %s: %s\n' "$url" "$time" "$desc"
done
