# Makefile: adjust-pop
# Location: individual/census/adjust-pop/
# Author: LMN

.PHONY: all clean

# --- Output files ---
OUTDIR = output

HHINC   = output/hhincome-census-final.csv
COMBINE = output/combine-census-final.csv
POP  = output/pop-1-19-census-final.csv
RACE   = output/race-census-final.csv

all: $(HHINC) $(COMBINE) $(POP) $(RACE)

$(HHINC): src/adjust-hhincome.R
	Rscript --vanilla $<

$(COMBINE): src/adjust-combine.R
	Rscript --vanilla $<


$(RACE): src/adjust-race.R
	Rscript --vanilla $<

$(POP): src/adjust-1-19-pop.R
	Rscript --vanilla $<


clean:
	rm -f output/*.csv

