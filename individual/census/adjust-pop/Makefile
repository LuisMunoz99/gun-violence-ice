# Makefile: adjust-pop
# Location: individual/census/adjust-pop/
# Author: LMN

.PHONY: all clean

# --- Output files ---
OUTDIR = output

HHINC   = output/hhincome-census-final.csv
COMBINED = output/hhincome-race-census-final.csv
POP  = output/pop-1-19-census-final.csv
RACE   = $output/race-census-final.csv

all: $(HHINC) $(COMBINED) $(POP) $(RACE)

$(HHINC): src/adjust-hhincome.R
	Rscript --vanilla $<

$(COMBINED): src/adjust-hhincome-race.R
	Rscript --vanilla $<


$(RACE): src/adjust-race.R
	Rscript --vanilla $<

$(POP): src/adjust-1-19-pop.R
	Rscript --vanilla $<


clean:
	rm -f output/*.csv

