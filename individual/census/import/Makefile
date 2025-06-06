# Makefile: Import census data
# Autor: LMN


HHINC_OUT       = output/hhincome-census.csv
RACE_OUT        = output/race-census.csv
POP_OUT         = output/pop-1-19-census.csv
COMBINED_OUT    = output/hhincome-race-census.csv

HHINC_VARS      = notes/hhincome-vars.txt
RACE_VARS       = notes/race-vars.txt
POP_VARS        = notes/pop-vars.txt
COMBINED_VARS   = notes/hhincome-race-vars.txt


all: $(HHINC_OUT) $(RACE_OUT) $(POP_OUT) $(COMBINED_OUT) \
     $(HHINC_VARS) $(RACE_VARS) $(POP_VARS) $(COMBINED_VARS)


$(HHINC_OUT) $(HHINC_VARS): src/import-hhincome.R
	Rscript --vanilla $<

$(RACE_OUT) $(RACE_VARS): src/import-race.R
	Rscript --vanilla $<

$(POP_OUT) $(POP_VARS): src/import-1-19-pop.R
	Rscript --vanilla $<

$(COMBINED_OUT) $(COMBINED_VARS): src/import-combine.R
	Rscript --vanilla $<

clean:
	rm -f output/*.csv notes/*.txt

