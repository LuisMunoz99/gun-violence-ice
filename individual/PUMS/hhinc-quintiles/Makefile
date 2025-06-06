# Makefile: PUMS Household Income quintiles
# Author: LMN

# Inputs
input = ../import/output/pums-hhinc.csv

# output
quintile = output/hhinc-quintiles.csv


all: $(quintile) 

$(quintile): src/hhinc-quintiles.R $(input)
	Rscript --vanilla $<


clean:
	rm -f $(quintile)
