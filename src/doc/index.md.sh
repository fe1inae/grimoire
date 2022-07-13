cd "$(dirname "${0}")" || true

cat <<'EOF'
posts
=====

EOF

for f in *; do
	case "$f" in
	*.md)
		printf '[%s: %s - %s]([%%protocol]://ulthar.cat/doc/%s[%%extension])\n\n' \
			"$(lowdown -Xdate "${f}")" \
			"$(lowdown -Xtitle "${f}")" \
			"$(lowdown -Xsummary "${f}")" \
			"${f%md}"
			
		;;
	esac
done | sort -nr
