cd "${0%/*}" || true

cat <<'EOF'
# misc
random documents and stuff

EOF

for f in *; do
	case "$f" in
	*.gmi.sh) f="${f%.sh}"; printf '=> %s\n' "${f%.gmi}.ext" ;;
	*.gmi)    printf '=> %s\n' "${f%.gmi}.ext" ;;
	*.sh)     printf '=> %s\n' "${f%.sh}" ;;
	*)        printf '=> %s\n' "$f" ;;
	esac
done
