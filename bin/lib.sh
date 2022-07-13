#!/bin/sh

#shellcheck disable=SC2254
match() {
	case "${1}" in
	${2}) return 0 ;;
	*) return 1 ;;
	esac
}

# log
log() {
	if [ -n "${NO_COLOR:-""}" ]; then
		printf '[%s] %s\n' \
			"${P:-LOG}" "${1}"
	else
		printf '%b %s \033[0m %s\n' \
			"${C:-\033[7;1m}" "${P:-LOG}" "${1}" \
			> /dev/stderr
	fi >&2
}

task() { C="\033[7;36m" P="TASK" log "${1}"; }
notify() { C="\033[7;35m" P="NOTE" log "${1}"; }
lmake() { C="\033[7;32m" P="MAKE" log "$(realpath "${1}")"; }
lskip() {
	if [ "${VERBOSE}" = "1" ]; then
		C="\033[7;33m" P="SKIP" log "$(realpath "${1}")"
	fi
}

# x is newer than y
isolder() {
	if [ "${FORCE}" = "1" ]; then
		return 1
	else
		test \
			"$(stat -c %Y "${1}" 2> /dev/null)" \
			-lt \
			"$(stat -c %Y "${2}" 2> /dev/null)" \
			2> /dev/null
	fi
}
