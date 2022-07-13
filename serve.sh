#!/bin/sh
set -eu
cd "$(dirname "$(realpath "$0")")"

DEFAULT_IN=${PWD}/out/html
DEFAULT_OUT=/www

GIT_IN="${GIT_PATH:-"$HOME/git"}"

DYNAMIC="
awk
git
gzip
highlight
lowdown
lzip
mandoc
sed
sh
tar
httpd
tr
env
"

# check dependencies
for f in $DYNAMIC; do
	if ! command -v "$f" >/dev/null 2>&1; then
		printf 'error: command %s not found\n' "$f" >&1
		exit 1
	fi
done

# copy cgit
mkdir -p ${DEFAULT_IN}/cgi-bin
cp -f /usr/share/webapps/cgit/cgit     ${DEFAULT_IN}/cgi-bin/cgit
cp -f /usr/share/webapps/cgit/cgit.css ${DEFAULT_IN}/css/cgit.css

# launch bwrap
(exec env -i bwrap $(awk '{ sub(/#.*$/, ""); printf("%s ", $0) }' <<-EOF
	# libraries
	$(
		for f in $DYNAMIC; do
			lib="$(ldd "$(which "${f}")" | awk '{if (NF == 2) print $1; else print $3 }')"
			for l in $lib; do
				printf '--ro-bind %s %s\n' "$l" "$l"
			done
		done | sort | uniq
	)

	# binaries
	$(
		for f in $DYNAMIC; do
			printf '--ro-bind %s /bin/%s\n' "$(which "${f}")" "${f}"
		done
	)

	# sys
	--dev   /dev
	--proc  /proc
	--tmpfs /tmp
	
	# httpd config
	--ro-bind ${PWD}/etc/httpd.conf /etc/httpd.conf

	# default
	--ro-bind ${DEFAULT_IN} ${DEFAULT_OUT}

	# cgit stuff
	--ro-bind ${GIT_IN}               /var/git
	--ro-bind ${PWD}/etc/cgit/cgitrc  /etc/cgitrc
	--ro-bind ${PWD}/etc/cgit/filter  /lib/cgit/filter
	--dir /cache/cgit

	# highlight
	--ro-bind /etc/highlight          /etc/highlight
	--ro-bind /usr/share/highlight    /usr/share/highlight
	
	# restrictions
	--hostname RESTRICTED
	--unshare-all
	--share-net
	--die-with-parent
	--new-session

	# run
	httpd
		-f      # foreground
		-p 8002 # port
		-h /www # chdir
EOF
))

