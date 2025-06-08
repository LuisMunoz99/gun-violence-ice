# # Makefile: Combine ICE components
# Author: LMN
# Date: 2025-06-06
# Description: Runs ice-value.R to generate ICE-combined file

out      = output/ice-hhincome.csv

.PHONY: all clean

all: $(out)

$(out): src/ice-value.R
	Rscript --vanilla $<

clean:
	rm -f $(out) 


