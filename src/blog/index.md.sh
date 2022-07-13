cd "$(dirname "${0}")" || true

cat <<'EOF'
title: fels blog

posts
=====

EOF

for f in *; do
	case "$f" in
	*.md)
		printf '[%s]([%%protocol]://ulthar.cat/doc/%s[%%extension]): %s - %s\n\n' \
			"$(lowdown -Xdate "${f}")" \
			"${f%md}" \
			"$(lowdown -Xtitle "${f}")" \
			"$(lowdown -Xsummary "${f}")"
			
		;;
	esac
done | sort -nr
