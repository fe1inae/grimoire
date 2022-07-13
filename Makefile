.PHONY: all fix watch FRC
	
# VARIABLES
# =========

DIR=/var/gemini

SRC=$(shell find src/ -type f)

OUT=$(SRC:src/%=$(DIR)/%)

MISC=                     \
	$(DIR)/style.css      \
	$(DIR)/unscii-16.woff
	

# GENERATORS
# ==========

all: $(OUT) $(MISC)

$(DIR)/%.gmi: src/%.gmi FRC
	@mkdir -p $(@D)
	@cat $(<)                  \
		| awk -f bin/shell.awk \
		| fold -s              \
		> $(@)
	@echo $(@)

$(DIR)/%: src/% FRC
	@mkdir -p $(@D)
	@cp -f $(<) $(@)
	@echo $(@)
	
$(DIR)/%: css/% FRC
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

FRC:
