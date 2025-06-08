# Makefile: Create symbolic links for ICE exports
# Author: LMN

# input 
hhincome = ../hhincome/output/ice-hhincome.csv
combine = ../combine/output/ice-combine.csv

# output 
sym-hhincome = output/ice-hhincome.csv
sym-combine = output/ice-combine.csv


.PHONY: all clean

all: $(sym-hhincome) $(sym-combine)

$(sym-hhincome): $(hhincome)
	ln -sf $(abspath $<) $@

$(sym-combine): $(combine)
	ln -sf $(abspath $<) $@

clean:
	rm -f $(sym-hhincome) $(sym-combine)

