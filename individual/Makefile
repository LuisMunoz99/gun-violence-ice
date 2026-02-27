# Makefile: individual
# Location: individual/
# Author: LMN

.PHONY: all regdem pums census clean

all: regdem pums census

regdem:
	$(MAKE) -C regdem

pums:
	$(MAKE) -C PUMS

census:
	$(MAKE) -C census

clean:
	$(MAKE) -C regdem clean
	$(MAKE) -C PUMS clean
	$(MAKE) -C census clean
