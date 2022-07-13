cd "$(dirname "${0}")" || true

cat <<'EOF'
misc
====

random documents and stuff

EOF

for f in *; do
	[ "${f}" = index.md.sh ] && continue
	
	case "$f" in
	*.md.sh) url="${f%.md.sh}.[%extension]" ;;
	*.md)    url="${f%.md}.[%extension]" ;;
	*.sh)    url="${f%.sh}" ;;
	*)       url="${f}" ;;
	esac
	name="$(printf '%s\n' "$url" | sed 's/-/ /g; s/\.[%extension]$//g')"
	printf '[%s](%s)\n\n' "${name}" "${url}"
done
