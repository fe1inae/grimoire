.PHONY: all fix watch
	
# VARIABLES
# =========

DIR=/var/gemini

SRC=$(shell find src/ -type f)

OUT=$(SRC:src/%=$(DIR)/%)

MISC=                     \
	$(DIR)/pkg            \
	$(DIR)/style.css      \
	$(DIR)/unscii-16.woff

# GENERATORS
# ==========

all: $(OUT) $(MISC)

$(DIR)/%.gmi: src/%.gmi
	@mkdir -p $(@D)
	@cat $(<)                  \
		| awk -f fmt/shell.awk \
		| fold -s              \
		> $(@)
	@echo $(@)

$(DIR)/%: src/%
	@mkdir -p $(@D)
	@cp -f $(<) $(@)
	@echo $(@)
	
$(DIR)/%: css/%
	@mkdir -p $(@D)
	@cp -f $(<) $(@)
	@echo $(@)

# MISC
# ====

watch:
	lr -t 'type == f' css fmt src \
		| rwc | xe -s '$(MAKE)'

fix:
	$(MAKE)
