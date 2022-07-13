.POSIX:
.SUFFIXES:
.PHONY: all test 

WWW=$(PUBLIC)/www/html
REPO=/home/fel/git

E= \
	REPODIR=$(REPO) \
	URL=https://ulthar.cat \
	GITURL=https://ulthar.cat/git

all:
	@$(E) sh bin/generate.sh -t $(WWW)

test:
	@$(E) sh bin/generate.sh -t test -v
	
serv:
	cd test && darkhttpd .

check:
	@shellcheck                     \
		-s sh                       \
		-e 2154,1090                \
		-o add-default-case         \
		-o avoid-nullary-conditions \
		-o check-set-e-suppressed   \
		-o deprecate-which          \
		-o quote-safe-variables     \
		-o require-variable-braces  \
		bin/*
	
fmt:
	@shfmt        \
		-ln posix \
		-i 0      \
		-bn       \
		-sr       \
		-kp       \
		-w bin/*
