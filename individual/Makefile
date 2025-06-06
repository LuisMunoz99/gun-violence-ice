# Makefile: Importing INDIVIDUAL sources of information
# Author: LMN

.PHONY: all regdem pums census clean

all: regdem pums census

regdem:
	$(MAKE) -C regdem

pums:
	$(MAKE) -C PUMS

census:
	$(MAKE) -C census/import

clean:
	$(MAKE) -C regdem clean
	$(MAKE) -C PUMS clean
	$(MAKE) -C census/import clean

