#!/bin/sh
set -eu

DEFAULT_IN=${PWD}/out/html
DEFAULT_OUT=/www/default.website

GIT_IN=/home/fel/git

(exec bwrap $(awk '{ sub(/#.*$/, ""); printf $0 " " }' <<-EOF
	# libs
	--ro-bind /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
	--ro-bind /lib/libz.so.1           /lib/libz.so.1
	--ro-bind /usr/lib/libgcc_s.so.1   /usr/lib/libgcc_s.so.1
	--ro-bind /usr/lib/liblua-5.3.so.0 /usr/lib/liblua-5.3.so.0
	--ro-bind /usr/lib/liblua-5.4.so.0 /usr/lib/liblua-5.4.so.0
	--ro-bind /usr/lib/libmandoc.so    /usr/lib/libmandoc.so
	--ro-bind /usr/lib/libstdc++.so.6  /usr/lib/libstdc++.so.6

	# minimum utils
	--ro-bind $(which awk)  /bin/awk
	--ro-bind $(which sed)  /bin/sed
	--ro-bind $(which sh)   /bin/sh 
	--ro-bind $(which tar)  /bin/tar
	--ro-bind $(which tr)   /bin/tr
	--ro-bind $(which gzip) /bin/gzip

	# bin
	--ro-bind $(which althttpd)  /bin/althttpd
	--ro-bind $(which lowdown)   /bin/lowdown
	--ro-bind $(which highlight) /bin/highlight
	--ro-bind $(which mandoc)    /bin/mandoc
	--ro-bind $(which mandoc)    /bin/mandoc

	# sys
	--dev   /dev
	--proc  /proc
	--tmpfs /tmp

	# default
	--ro-bind ${DEFAULT_IN} ${DEFAULT_OUT}


	# git stuff
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
	althttpd 
		-https 1   # use https
		-jail 0    # disable builtin jail, we do our own
		-root /www # set root to chroot www
		-port 8002
EOF
))

