# XXX: header/foot
build/gmi/%.gmi: tmp/%.gmi
	@mkdir -p "$(@D)"
	@awk -f bin/unwrap.awk "${<}"      \
		| sed '                        \
			s;\.ext;.gmi;g;            \
			s;protocol://;gemini://;g; \
		'                              \
		> "${@}"
	@echo "${<} -> ${@}"

# fallback copy
build/gmi/%: tmp/%
	@mkdir -p "$(@D)"
	@cp -f "${<}" "${@}"
	@echo "${<} -> ${@}"

