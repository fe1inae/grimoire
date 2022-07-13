cd "${0%/*}"

cat <<'EOF'
.Dd $Mdocdate$
.Dt "documents and stuffs" 7
.Os "ulthar cat"
.Sh posts
.Pp
blog/rants/etc. rampant incoherency, so be warned :P

.Bd -unfilled -compact
EOF
for f in *; do
	case "$f" in
	*.mdoc)
		printf '%s %s %s\n' \
			"$(sed -n 's/^.Dd \(.*\)/\1/ p' "$f")" \
			"${f%.mdoc}.ext" \
			"$(sed -n 's/^.Dt "\([^"]*\)".*/\1/ p' "$f")"
		;;
	esac
done | sort -nr | while read -r line; do
	set -- $line
	time="$1"
	url="$2"
	shift; shift
	desc="$@"
	printf '.Lk protocol://ulthar.cat/doc/%s %s - %s\n' "$url" "$time" "$desc"
done
	
printf '.Ed\n'
