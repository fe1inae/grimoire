#!/bin/sh
set -eu

DEFAULT_IN=/home/fel/grm/out/html
DEFAULT_OUT=/www/default.website

GIT_IN=/home/fel/git

(exec bwrap $(awk '{ sub(/#.*$/, ""); printf $0 " " }' <<-EOF
	# libs
	--ro-bind /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
	--ro-bind /lib/libz.so.1           /lib/libz.so.1
	--ro-bind /usr/lib/liblua-5.3.so.0 /usr/lib/liblua-5.3.so.0

	# bin
	--ro-bind /usr/bin/althttpd /bin/althttpd

	# sys
	--dev   /dev
	--proc  /proc
	--tmpfs /tmp

	# default
	--ro-bind ${DEFAULT_IN} ${DEFAULT_OUT}

	# git directory
	--ro-bind ${GIT_IN}         /var/git
	--ro-bind ${PWD}/etc/cgitrc /etc/cgitrc

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

