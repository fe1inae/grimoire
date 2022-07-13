#!/bin/sh
set -eu
. bin/lib.sh

task "MAKING GEMINI"

# INIT VARS
# =========

OPT_VERBOSE=0
OPT_FORCE=0

# PARSE ARGS
# ==========

while [ "${#}" -gt 0 ]; do
	case "${1}" in
	-t)
		shift
		WWW="${1}"
		;;
	-v) OPT_VERBOSE=1 ;;
	-f) OPT_FORCE=1 ;;
	*) ;;
	esac
	shift
done

FORCE="${OPT_FORCE}"
VERBOSE="${OPT_VERBOSE}"

# FUNCTIONS
# =========

# generate a gmi page
mkgmi() {
	cat "${f}" \
		| sed 's;\.ext;.gmi;g' \
		| sed 's;protocol://;gemini://;g' \
		| sh bin/gmni/pre.sh \
		| mandoc \
			-mdoc \
			-Tutf8 \
			-Ios="ulthar cat" \
		| col -bx \
		| sh bin/gmni/post.sh
}

# PROCESSING STAGE
# ================

# .SH FILES
# ---------

notify "SOURCE TREE"
find src -type f | while IFS= read -r f; do
	[ -e "${f}" ] || continue
	out="tmp/gmni/${f#src/}"
	ext="${f##*.}"
	out="${out%."${ext}"}"
	mkdir -p "${out%/*}"
	case "${f}" in
	*.sh)
		if isolder "${f}" "${out}"; then
			lskip "${out}"
		else
			lmake "${out}"
			sh "${f}" > "${out}"
		fi
		;;
	*)
		if isolder "${f}" "${out}.${ext}"; then
			lskip "${f}.${ext}"
		else
			lmake "${out}.${ext}"
			cp -f "${f}" "${out}.${ext}"
		fi
		;;
	esac
done

# XXX GIT
# -------

sh bin/gmni/git.sh

# dumb overview, make index/tree with description
# and readme/licenses?

# GENERATE MISC INDEX
# ===================

notify "MISC INDEXES"
find tmp/gmni -type d | while IFS= read -r d; do
	[ -e "${d}/index.gmi" ] && continue
	[ -e "${d}/index.mdoc" ] && continue
	(
		cd "${d}"
		printf '# index of %s\n\n' "${d#tmp/gmni}"
		for f in *; do
			#shellcheck disable=SC2310
			match "${f}" "*index.gmi" && continue
			#shellcheck disable=SC2310
			if [ -d "${f}" ] || match "${f}" "*.gmi"; then
				printf '=> %s\n' "${f}"
			fi
		done
	) > "${d}/index.gmi.frc"
	lmake "${d}/index.gmi.frc"
done

# WRITE FILES
# ===========

notify "FINAL CONVERSION"
find tmp/gmni -type f -o -type l | while IFS= read -r f; do
	[ -e "${f}" ] || continue

	# check for force flag on files
	# and make output shiz
	name="${f}"
	if match "${f}" "*.frc"; then
		name="${f%.frc}"
		out="${WWW}/${name#tmp/gmni/}"
		ext="${name##*.}"
		FORCE=1
	else
		FORCE="${OPT_FORCE}"
		out="${WWW}/${name#tmp/gmni/}"
		ext="${name##*.}"
	fi

	# check if no extension, else add dot
	if [ "${ext}" = "${f}" ]; then
		ext=""
	else
		ext=".${ext}"
	fi

	out="${out%"${ext}"}"
	mkdir -p "${out%/*}"

	# process and build files
	case "${name}" in
	*.mdoc)
		if isolder "${f}" "${out}.gmi"; then
			lskip "${out}.gmi"
		else
			lmake "${out}.gmi"
			mkgmi "${f}" > "${out}.gmi"
		fi
		;;
	*)
		if isolder "${f}" "${out}${ext}"; then
			lskip "${out}${ext}"
		else
			lmake "${out}${ext}"
			cp -f "${f}" "${out}${ext}"
		fi
		;;
	esac
done
