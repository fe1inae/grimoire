.PHONY: all fix watch FRC
	
# VARIABLES
# =========

DIR=/var/gemini

SRC=$(shell find src/ -type f)

OUT=$(SRC:src/%=$(DIR)/%)

MISC=                     \
	css/fel.png           \
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

$(DIR)/%.sh: src/%.sh FRC
	@mkdir -p $(@D)
	@sh $(<) > $(@:$(DIR)/%.sh=$(DIR)/%)

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

css/fel.png: 
	@cp -f $$HOME/pic/art/avatars/FEL_CURRENT.png $(@)

fix:
	rm -f $(OUT)
	$(MAKE)

FRC:
