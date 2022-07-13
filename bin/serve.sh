#!/bin/sh
set -eu

DEFAULT_IN=/home/fel/grm/out/html
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
	--ro-bind /bin/awk     /bin/awk
	--ro-bind /bin/sed     /bin/sed
	--ro-bind /bin/sh      /bin/sh 
	--ro-bind /bin/tar     /bin/tar
	--ro-bind /usr/bin/tr  /bin/tr

	# bin
	--ro-bind /usr/bin/althttpd  /bin/althttpd
	--ro-bind /usr/bin/lowdown   /bin/lowdown
	--ro-bind /usr/bin/highlight /bin/highlight
	--ro-bind /usr/bin/mandoc    /bin/mandoc

	# XXX removeme
	--ro-bind /etc/passwd /etc/passwd

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

