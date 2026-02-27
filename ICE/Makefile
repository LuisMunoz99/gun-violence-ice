# Makefile: ICE
# Location: ICE/
# Author: LMN

.PHONY: all combine hhincome export clean

all: combine hhincome export

combine:
	$(MAKE) -C combine

hhincome:
	$(MAKE) -C hhincome

export:
	$(MAKE) -C export

clean:
	$(MAKE) -C combine clean
	$(MAKE) -C hhincome clean
	$(MAKE) -C export clean

