.PHONY: all clean

WWW=${HOME}/var/public/www

include Makefile.in

build: ${SRC}
	@rm -rf tmp

push: all
	rm -rf ${WWW}/*
	cp -rf build/* ${WWW}
	

include mk/default.mk
include mk/gemini.mk
include mk/html.mk

Makefile.in:; @sh bin/generate.sh > Makefile.in
clean:; -rm -rf tmp build Makefile.in
