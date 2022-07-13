#!/bin/sh
set -eu

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

# UTIL FUNCS
# ==========

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
			"${P:-LOG}" "$1"
	else
		printf '%b %s \033[0m %s\n' \
			"${C:-\033[7;1m}" "${P:-LOG}" "$1" \
			> /dev/stderr
	fi >&2
}
notify() { C="\033[7;35m" P="NOTE" log "$1"; }
lmake() { C="\033[7;32m" P="MAKE" log "$(realpath "$1")"; }
lskip() {
	if [ "${VERBOSE}" = "1" ]; then
		C="\033[7;33m" P="SKIP" log "$(realpath "$1")"
	fi
}

# x is newer than y
isolder() {
	if [ "${FORCE}" = "1" ]; then
		return 1
	else
		test \
			"$(stat -c %Y "$1" 2>/dev/null)" \
			-lt \
			"$(stat -c %Y "$2" 2>/dev/null)" \
			2> /dev/null
	fi
}

# FUNCTIONS
# =========

# generate an html page
mkhtml() {
	tr -d '\n' < etc/head.html
	sh bin/mksidebar.sh "${f}"
	printf '<article>'
	sed 's/\.ext/.html/g' "${f}" \
		| mandoc \
			-mdoc \
			-Thtml \
			-O fragment
	printf '</article>'
	tr -d '\n' < etc/foot.html
}

# fix externally generated html (stagit)
fixhtml() {
	tr -d '\n' < etc/head.html
	sh bin/mksidebar.sh "${f}"
	printf '<article>'
	cat "${f}"
	printf '</article>'
	tr -d '\n\t ' < etc/foot.html
}

# PROCESSING STAGE
# ================

# .SH FILES
# ---------

notify "SOURCE TREE"
find src -type f | while IFS= read -r f; do
	[ -e "${f}" ] || continue
	out="tmp/${f#src/}"
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

# STAGIT
# ------

# XXX generate repo list

notify "GENERATING REPOS"
repos="$(
	find "${REPODIR}" -name "git-daemon-export-ok" | while IFS= read -r d; do
		d="${d%/*}"
		name="${d#"${REPODIR}"/}"
		name="${name%.git}"
		mkdir -p "tmp/git/${name}"
		(
			cd "tmp/git/${name}"
			if [ "$(git log -1 --pretty=%ct)" -lt "$(stat -c %Y log.html 2>/dev/null)" ] 2>/dev/null; then
				lskip "."
			else
				lmake "."
				stagit -u "${GITURL}/${name}/" "${d}"
				ln -snf log.html index.html
				if [ -f "${d}/logo.png" ]; then
					cp -f "${d}/logo.png" .
				fi
			fi
		)
		printf '%s ' "${d}"
	done
)"

(
	# last commit  - name (tree) - description
	cat << EOF
<table>
$(
		printf '<table><h1>repositories</h1></table>'
		printf '<hr>'
		printf '<table>'
		printf '<thead><tr><td><b>last commit</b></td><td><b>name</b></td><td><b>description</b></td></tr></thead>'
		for r in ${repos}; do
			name="${r#"${REPODIR}"/}"
			name="${name%.git}"
			(
				cd "${r}"
				printf '<tr>'
				printf '<td>%s</td>' "$(git log -1 --pretty=%as)"
				printf '<td><a href="%s">%s</a></td>' "${name}" "${name}"
				printf '<td>%s</td>' "$(cat description)"
				printf '</tr>\n'
			)
		done | sort -nr
		printf '</table>'
	)
</table>
EOF
) | tr -d '\n' > tmp/git/index.html
lmake "tmp/git/index.html"

# GENERATE MISC INDEX
# ===================

notify "MISC INDEXES"
find tmp -type d | while IFS= read -r d; do
	[ -e "${d}/index.html" ] && continue
	[ -e "${d}/index.mdoc" ] && continue
	(
		cd "${d}"
		printf '<table><h1>index of %s</h1></table>' "${d#tmp}"
		printf '<hr>'
		printf '<table>'
		for f in *; do
			#shellcheck disable=SC2310
			match "${f}" "*index.html" && continue
			#shellcheck disable=SC2310
			if [ -d "${f}" ] || match "${f}" "*.html"; then
				printf '<tr>'
				printf '<td><a href="%s">%s</a></td>' "${f}" "${f}"
				printf '</tr>'
			fi
		done
		printf '</table>'
	) > "${d}/index.html.frc"
	lmake "${d}/index.html.frc"
done

# WRITE FILES
# ===========

notify "FINAL CONVERSION"
find tmp -type f -o -type l | while IFS= read -r f; do
	[ -e "${f}" ] || continue

	# check for force flag on files
	# and make output shiz
	if match "$f" "*.frc"; then
		tmp="${f%.frc}"
		out="${WWW}/${tmp#tmp/}"
		ext="${tmp##*.}"
		FORCE=1
	else
		FORCE="$OPT_FORCE"
		out="${WWW}/${f#tmp/}"
		ext="${f##*.}"
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
	case "${f}" in
	*.mdoc) 
		if isolder "${f}" "${out}.html"; then
			lskip "${out}.html"
		else
			lmake "${out}.html"
			mkhtml "${f}" > "${out}.html"
		fi
		;;
	*.html)
		if isolder "${f}" "${out}.html"; then
			lskip "${out}.html"
		else
			lmake "${out}.html"
			fixhtml "${f}" > "${out}.html"
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
