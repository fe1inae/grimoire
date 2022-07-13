#!/bin/sh
set -e
cd "$(dirname "$(realpath "${0}")")"

# IMPORT
# ======

. utils.sh

# MAIN
# ====

main()
{
	# CGI STUFF
	# ---------

	mkdir -p www/cgi-bin
	mkdir -p www/css
	cp -f /usr/share/webapps/cgit/cgit     www/cgi-bin/cgit
	cp -f /usr/share/webapps/cgit/cgit.css www/css/cgit.css
	
	# GENERATE MISC
	# -------------
	
	find src -type f | while read -r fin
	do
		# format the output location
		fout="$(
			printf '%s\n' "${fin}" | sed '
				s;src/\(.*\);www/\1;g   # change beginning of path
				s;\(.*\)\.sh$;\1;g      # trim off shell
				s;\(.*\)\.md$;\1.html;g # change extension
			'
		)"
		
		# check if needs updating
		isolder -1 "${fin}" -2 "${fout}" && continue
		
		# log building
		info "${fout} -> ${fout}"
		
		# build skel
		mkdir -p "$(dirname "${fout}")"
		
		# build depending on input type
		case "${fin}" in
		*.md.sh) sh "${fin}" | md2html > "${fout}" ;;
		*.md)    md2html < "${fin}"    > "${fout}" ;;
		*.sh)    sh "${fin}"           > "${fout}" ;;
		*)       cp -f "${fin}"          "${fout}" ;;
		esac
	done
}

main "$@" < /dev/stdin
