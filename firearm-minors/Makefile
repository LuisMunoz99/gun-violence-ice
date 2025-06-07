# firearm-minors/Makefile

.PHONY: all clean import geocode export

all: import geocode export

export:
	$(MAKE) -C export

geocode:
	$(MAKE) -C geocode

import:
	$(MAKE) -C import

clean:
	$(MAKE) -C export clean
	$(MAKE) -C geocode clean
	$(MAKE) -C import clean

