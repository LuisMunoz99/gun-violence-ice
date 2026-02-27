# ========================================
# Makefile: Census (master)
# Location: individual/census/
# Author: LMN
# ========================================

.PHONY: all import adjust symlinks clean

# ----------- Output Paths --------------
ADJDIR = adjust-pop/output
EXPDIR = export/output

HHINC      = $(ADJDIR)/hhincome-census-final.csv
HHINC_RACE = $(ADJDIR)/combine-census-final.csv
POP_1_19   = $(ADJDIR)/pop-1-19-census-final.csv
RACE       = $(ADJDIR)/race-census-final.csv

all: import adjust symlinks


symlinks: $(HHINC) $(HHINC_RACE) $(POP_1_19) $(RACE)
	@mkdir -p $(EXPDIR)
	@echo "→ Creating symlinks in $(EXPDIR)"
	ln -sf $(abspath $(HHINC))      $(EXPDIR)/
	ln -sf $(abspath $(HHINC_RACE)) $(EXPDIR)/
	ln -sf $(abspath $(POP_1_19))   $(EXPDIR)/
	ln -sf $(abspath $(RACE))       $(EXPDIR)/

adjust:
	$(MAKE) -C adjust-pop

import:
	$(MAKE) -C import


clean:
	$(MAKE) -C import clean
	$(MAKE) -C adjust-pop clean
	rm -f $(EXPDIR)/*.csv
	@echo "✓ Cleaned all outputs"

