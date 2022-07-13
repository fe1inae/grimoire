.PHONY: all fix link

# VARIABLES
# =========

SRC=$(shell find src/ -type f)

OUT=$(SRC:src/%=out/%)

MISC=out/pkg

# GENERATORS
# ==========

all: $(OUT) $(MISC)

out/pkg:
	@ln -snvf /home/fel/pkg/pub $(@)

out/%.gmi: src/%.gmi
	@mkdir -p $(@D)
	@cat $(<)                  \
		| awk -f fmt/shell.awk \
		| fold -s              \
		> $(@)
	@echo $(@)

out/%: src/%
	@mkdir -p $(@D)
	@cp -f $(<) $(@)
	@echo $(@)

# MISC
# ====

fix:
	rm -rf out
	$(MAKE)
