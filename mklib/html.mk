build/html/%.html: tmp/%.gmi
	@mkdir -p "$(@D)"
	@:> "${@}"
	@tr -d '\n\t' < etc/head.html >> "${@}"
	@sh bin/htmlheader.sh "${*}.html" >> "${@}"
	@printf '<article>' >> "${@}"
	@awk -f bin/unwrap.awk "${<}"          \
		| sed '                            \
			s;\.ext;.html;g;               \
			s;protocol://;https://;g;      \
		'                                  \
		| awk -f bin/gmi2html.awk          \
		>> "${@}"
	@printf '</article>' >> "${@}"
	@tr -d '\n\t' < etc/foot.html >> "${@}"
	@echo "${<} -> ${@}"

# shell
tmp/%: src/%.sh
	@mkdir -p "$(@D)"
	@sh "${<}" > "${@}"
	@echo "${<} -> ${@}"

# fallback copy
build/html/%: tmp/%
	@mkdir -p "$(@D)"
	@cp -f "${<}" "${@}"
	@echo "${<} -> ${@}"

