# SETTINGS
# --------

MANDOC_OPTS= \
	-Ios=ulthar.cat \
	-Kutf-8 \
	-mdoc 

# VARIABLES
# ---------

IN=\
	$(shell find src/ -type f -name '*.mdoc') \
	$(shell find src/ -type f -name '*.sh')

MIDDLE=\
	$(IN:src/%.mdoc=tmp/%.mdoc) \
	$(IN:src/%.sh=tmp/%.mdoc)

OUT=\
	$(MIDDLE:tmp/%.mdoc=out/html/%.html) \
	$(MIDDLE:tmp/%.mdoc=out/plain/%.txt)

# GENERATORS
# ----------

all: $(IN) $(MIDDLE) $(OUT)

tmp/%.mdoc: src/%.sh
	mkdir -p $(dir $(@))
	sh $(<) > $(@)

tmp/%.mdoc: src/%.mdoc
	mkdir -p $(dir $(@))
	cp -f $(^) $(@)

out/html/%.html: tmp/%.mdoc
	mkdir -p $(dir $(@))
	cp -f css/style.css out/html/style.css
	sed 's/\.EXT/.html/g' $(^) \
		| mandoc $(MANDOC_OPTS) \
			-Thtml \
			-Ostyle=/style.css \
			>> $(@)
	
out/plain/%.txt: tmp/%.mdoc
	mkdir -p $(dir $(@))
	sed 's/\.EXT/.txt/g' $(^) \
		| mandoc $(MANDOC_OPTS) \
			-Tutf8 \
			| col -bx > $(@)

# MISC
# ----

clean:
	git clean -Xdf

