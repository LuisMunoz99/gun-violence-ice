# Makefile: root
# Location: ./
# Author: LMN

.PHONY: all individual ice firearm merge clean

all: individual ice firearm merge

individual:
	$(MAKE) -C individual

ice: individual
	$(MAKE) -C ICE

firearm: individual
	$(MAKE) -C firearm-minors

merge: ice firearm
	$(MAKE) -C merge

clean:
	$(MAKE) -C individual clean
	$(MAKE) -C ICE clean
	$(MAKE) -C firearm-minors clean
	$(MAKE) -C merge clean
	@echo "✓ Cleaned full pipeline"
