# VARIABLES
# =========

FILTERS= \
	filter/lua/fix-links.lua

# ACTIONS
# =======

all: generate
	
generate: $(FILTERS)
	@rm -rf out
	@sh bin/generate.sh

diary:
	@sh bin/new_diary.sh

serve:
	@git pull -f
	@rm -rf out
	@sh bin/generate.sh

# RULES
# =====



# FILTERS
# =======

filter/lua/%.lua: filter/fnl/%.fnl
	@mkdir -p filter/lua
	fennel -c $< > $@

# SETUP
# =====

deps:
	@git submodule init
	@git submodule sync
	@git submodule update

clean:
	git clean -Xdf

