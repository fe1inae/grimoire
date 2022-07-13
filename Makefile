.POSIX:
.SUFFIXES:
.PHONY: all force test check fmt

WWW=$(PUBLIC)/www
REPO=/home/fel/git

E= \
	REPODIR=$(REPO) \
	URL=https://ulthar.cat \
	GITURL=https://ulthar.cat/git

all:
	@$(E) sh bin/html/generate.sh -t $(WWW)/html
	@$(E) sh bin/gmni/generate.sh -t $(WWW)/gmni

force:
	@$(E) sh bin/html/generate.sh -t $(WWW)/html -f
	@$(E) sh bin/gmni/generate.sh -t $(WWW)/gmni -f

test:
	@$(E) sh bin/html/generate.sh -t test/html -v -f
	@$(E) sh bin/gmni/generate.sh -t test/gmni -v -f
	
check:
	@shellcheck                     \
		-s sh                       \
		-e 2154,1090,2310           \
		-o add-default-case         \
		-o avoid-nullary-conditions \
		-o check-set-e-suppressed   \
		-o deprecate-which          \
		-o quote-safe-variables     \
		-o require-variable-braces  \
		bin/lib.sh bin/gmni/* bin/html/*
	
fmt:
	@shfmt        \
		-ln posix \
		-i 0      \
		-bn       \
		-sr       \
		-kp       \
		-w        \
		bin/lib.sh bin/gmni/* bin/html/*
