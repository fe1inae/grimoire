#!/bin/sh
set -eu
cd "$(dirname "$(realpath "$0")")"

# FUNCTIONS
# =========

# dsly to write rules
rule()
{
	printf 'rule %s\n command = %s\n description = %s\n' \
		"${1}" \
		"$(tr '\n\t' '  ')" \
		"${2}"
}


configure()
{
	# RULES
	# =====

	rule "fmt" "FMT \$out" <<- 'EOF'
		awk -f bin/unwrap.awk $in > $out;
	EOF

	rule "copy" "COPY \$out" <<- 'EOF'
		cp -f $in $out;
	EOF

	rule "shell" "SHELL \$out" <<- 'EOF'
		sh $in > $out;
	EOF

	rule "gmi2html" "HTML \$out" <<- 'EOF'
		:> $out;

		tr -d '\n\t' < etc/html/head.html >> $out;

		sh bin/html/header.sh $in >> $out;

		printf '<article>' >> $out;
		sed -f bin/html/replace.sed $in
			| awk -f bin/html/gmi2html.awk
			>> $out;
		printf '</article>' >> $out;

		tr -d '\n\t' < etc/html/foot.html >> $out;
	EOF

	rule "gmi2gmi" "GEM \$out" <<- 'EOF'
		sed -f bin/gemini/replace.sed $in > $out;
	EOF

	# BUILD TARGETS
	# =============

	find ext src -type f | while read -r fin; do
		# stage 1
		fcache="${fin}"
		fcache="${fcache#src/}"
		fcache="${fcache#ext/}"
		fcache="tmp/${fcache}"
		case "${fin}" in
		*.sh)
			fcache="${fcache%.sh}"
			printf 'build %s: shell %s\n' "${fcache}" "${fin}"
			;;
		*.gmi) printf 'build %s: fmt %s\n' "${fcache}" "${fin}" ;;
		*)  printf 'build %s: copy %s\n' "${fcache}" "${fin}" ;;
		esac

		# stage 2
		for i in html gmi; do
			fout="out/${i}/${fcache#tmp/}"

			case "${fcache}" in
			*.gmi) printf 'build %s: gmi2%s %s\n' \
				"${fout%.gmi}.${i}" "${i}" "${fcache}" ;;
			*) printf 'build %s: copy %s\n' \
				"${fout}" "${fcache}" ;;
			esac
		done

	done
}

# MAIN
# ====

# clean danglies from previous run
# ---------------------------------

if [ -e .ninja_build ]; then
	while read -r cmd fout _ fin; do
		[ "${cmd}" = "build" ] || continue
		fout="${fout%:}"
		if [ ! -e "${fin}" ]; then
			printf '[0/0] DEL %s\n' "${fout}"
			rm -f "${fout}"
		fi
	done < .ninja_build
fi

# generate build script and run
# -----------------------------

configure > .ninja_build
ninja -f .ninja_build "$@"