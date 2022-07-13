#!/bin/sh
set -eu

find  src -type f | {
	static=""
	while read -r fin; do

		# STAGE ONE
		# =========

		fcache="${fin}"
		fcache="${fcache#src/}"
		fcache="tmp/${fcache}"
		case "${fin}" in
		*.sh)
			fcache="${fcache%.sh}"
			printf 'build %s: run %s\n' "${fcache}" "${fin}"
			;;
		*.gmi)
			printf 'build %s: gemfmt %s\n' "${fcache}" "${fin}"
			;;
		*)
			printf 'build %s: copy %s\n'   "${fcache}" "${fin}"
			;;
		esac

		# STAGE TWO
		# =========

		for i in html gmi; do
			fout="out/${i}/${fcache#tmp/}"

			case "${fcache}" in
			*.gmi) 
				fout="${fout%.gmi}.${i}"
				printf 'build %s: gmi2%s %s\n' \
					"${fout}" "${i}" "${fcache}"
				;;
			*) 
				printf 'build %s: copy %s\n' "${fout}" "${fcache}" 
				;;
			esac
			static="${static} ${fout}"
		done
	done
	printf 'build static: phony %s\n' "${static}"
}
