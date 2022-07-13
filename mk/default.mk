# universal fallbacks

tmp/%: src/%
	@mkdir -p "$(@D)"
	@cp -f "${<}" "${@}"
	@echo "${<} -> ${@}"
tmp/%: src/%.sh
	@mkdir -p "$(@D)"
	@sh "${<}" > "${@}"
	@echo "${<} -> ${@}"

