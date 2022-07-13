#!/bin/sh

# UTILITIES
# =========

# no_color aware logging util
log()
{
	while getopts "p:f:b:" o
	do
		case "${o}" in
		p) prompt="${OPTARG}" ;; # prompt 
		f) fore="${OPTARG}" ;;   # foreground color
		b) back="${OPTARG}" ;;   # background color
		*) ;;
		esac
	done
	shift "$((OPTIND - 1))"
	
	if [ -n "${NO_COLOR}" ]
	then
		printf '[ %s ] %s' "${prompt:-log}" "$@"
	else
		printf '\033[%sm\033[%sm %s \033[0m %s\n' \
			"${back:-0;47}" "${fore:-30}" "${prompt:-"LOG "}" "$@"
	fi
}

# logging utils
fail() { log  -f '30' -b '0;41' -p "FAIL" "$@" > /dev/stderr; }
warn() { log  -f '30' -b '0;43' -p "WARN" "$@" > /dev/stderr; }
pass() { log  -f '30' -b '0;42' -p "PASS" "$@" > /dev/stderr; }
info() { log  -f '30' -b '0;47' -p "INFO" "$@" > /dev/stderr; }

# simple function to check if a file is older than another
isolder()
{
	while getopts "1:2:" o
	do
		case "${o}" in
		1) first="${OPTARG}" ;;
		2) second="${OPTARG}" ;;
		*) ;;
		esac
	done

	{
		[ "$(stat -c '%Y' "${first}")" -lt "$(stat -c '%Y' "${second}")" ]
	} 2>/dev/null
}

# preprocessing
pre()
{
	awk '
		BEGIN {
			class["@"] = "external"
			class[":"] = "internal"
		}
		
		{
			while (match($0, /[:@]\[[^]]*\]\([^)]*\)/)) {
				# get elements
				type = substr($0, RSTART, 1)
				link = substr($0, RSTART+1, RLENGTH-1)
				full = type link
				
				# escape each character
				ere =  ""
				for (i = 1; i <= length(full); i++) {
					c = substr(full, i, 1)
					if (c ~ /[[:alpha:]]/)
						ere = ere substr(full, i, 1)
					else
						ere = ere "\\" substr(full, i, 1)
				}
				
				gsub(ere, link "{ ." class[type] " }")
				
			}
			print
		}
	' /dev/stdin
}

# CONVERSION
# ==========

md2html()
{
	sed -e 's/\.md)/.html)/g' \
		| lowdown -s -T html --parse-math \
		| awk '
			/^<link rel="stylesheet/ {
				print
				sub(/.*href="/, "")
				sub(/".*/, "")
				sub(/css\/style.css/, "pic/favicon.ico")
				$0 = "<link rel=\"icon\" type=\"image/x-icon\" href=\"" $0 "\">"
			}
			
			{ print }
		'
}

md2gmi()
{
	sed -e 's/\.md)/.gmi)/g' \
		| lowdown -s -T gemini
}
