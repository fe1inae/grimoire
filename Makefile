.PHONY: build force push

WWW = ${HOME}/var/public/www

include Makefile.in

build: ${SRC}
	@rm -rf tmp

force: 
	rm -rf build
	make

push: all
	mkdir -p ${WWW}
	rm -rf ${WWW}/*
	cp -rf build/* ${WWW}

include mklib/default.mk
include mklib/gemini.mk
include mklib/html.mk

Makefile.in:; @sh bin/generate.sh > Makefile.in
clean:; -rm -rf tmp build Makefile.in
