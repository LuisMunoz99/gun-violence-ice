# Makefile: Import census data
# Autor: LMN

# Makefile: Import census data
# Author: LMN
# Purpose: Import household income, race, and child population data from ACS

# --------------------
# Paths to output files
# --------------------
HHINC_CSV  = output/hhincome-census.csv
RACE_CSV   = output/race-census.csv
POP_CSV    = output/pop-1-19-census.csv
COMB_CSV   = output/hhincome-race-census.csv

HHINC_TXT  = notes/hhincome-vars.txt
RACE_TXT   = notes/race-vars.txt
POP_TXT    = notes/pop-vars.txt
COMB_TXT   = notes/hhincome-race-vars.txt

# Done markers
HHINC_DONE = .done/hhincome.done
RACE_DONE  = .done/race.done
POP_DONE   = .done/pop.done
COMB_DONE  = .done/combine.done

# --------------------
# Default target
# --------------------
.PHONY: all clean

all: $(HHINC_CSV) $(RACE_CSV) $(POP_CSV) $(COMB_CSV) \
     $(HHINC_TXT) $(RACE_TXT) $(POP_TXT) $(COMB_TXT)

# --------------------
# Household income
# --------------------
$(HHINC_DONE): src/import-hhincome.R
	Rscript --vanilla $<
	mkdir -p .done
	touch $@

$(HHINC_CSV) $(HHINC_TXT): $(HHINC_DONE)

# --------------------
# Race
# --------------------
$(RACE_DONE): src/import-race.R
	Rscript --vanilla $<
	mkdir -p .done
	touch $@

$(RACE_CSV) $(RACE_TXT): $(RACE_DONE)

# --------------------
# Population 1–19
# --------------------
$(POP_DONE): src/import-1-19-pop.R
	Rscript --vanilla $<
	mkdir -p .done
	touch $@

$(POP_CSV) $(POP_TXT): $(POP_DONE)

# --------------------
# Combine race + income
# --------------------
$(COMB_DONE): src/import-combine.R
	Rscript --vanilla $<
	mkdir -p .done
	touch $@

$(COMB_CSV) $(COMB_TXT): $(COMB_DONE)

# --------------------
# Clean outputs
# --------------------
clean:
	rm -f output/*.csv notes/*.txt .done/*.done



