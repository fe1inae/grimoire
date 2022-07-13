cd "${0%/*}"

cat <<'EOF'
.Dd $Mdocdate$
.Dt "documents and stuffs" 7
.Os "ulthar cat"
.Sh FILES
.Bd -unfilled -compact
EOF
for f in *; do
	case "$f" in
	*.mdoc)
		printf '.Lk %s %s - %s\n' \
			"${f%.mdoc}.html" \
			"$(date -d @$(stat -c %Y "$f") +%Y%m%d)" \
			"${f%.mdoc}"
		;;
	esac
done
printf '.Ed\n'
