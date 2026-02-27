# Makefile: census/export
# Location: individual/census/export/
# Author: LMN

.PHONY: all clean

# --- Inputs ---
POP_SRC     = ../adjust-pop/output/pop-1-19-census-final.csv
HHINC_SRC   = ../adjust-pop/output/hhincome-census-final.csv
COMBINE_SRC = ../adjust-pop/output/combine-census-final.csv
RACE_SRC    = ../adjust-pop/output/race-census-final.csv

# --- Outputs ---
POP     = output/pop-1-19-census-final.csv
HHINC   = output/hhincome-census-final.csv
COMBINE = output/combine-census-final.csv
RACE    = output/race-census-final.csv

all: $(POP) $(HHINC) $(COMBINE) $(RACE)

$(POP): $(POP_SRC)
	mkdir -p output
	ln -sf $(abspath $<) $@

$(HHINC): $(HHINC_SRC)
	mkdir -p output
	ln -sf $(abspath $<) $@

$(COMBINE): $(COMBINE_SRC)
	mkdir -p output
	ln -sf $(abspath $<) $@

$(RACE): $(RACE_SRC)
	mkdir -p output
	ln -sf $(abspath $<) $@

clean:
	rm -f output/*.csv
