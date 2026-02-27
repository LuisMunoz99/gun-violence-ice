# ========================================
# Makefile: Census (master)
# Location: individual/census/
# Author: LMN
# ========================================

.PHONY: all import adjust export clean

all: import adjust export

import:
	$(MAKE) -C import

adjust:
	$(MAKE) -C adjust-pop

export:
	$(MAKE) -C export

clean:
	$(MAKE) -C import clean
	$(MAKE) -C adjust-pop clean
	$(MAKE) -C export clean
	@echo "✓ Cleaned all census outputs"
