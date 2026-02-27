# Makefile: merge
# Location: merge/
# Author: LMN

.PHONY: all clean

# --- Inputs ---
FIREARM_MINORS = ../firearm-minors/export/output/firearm-minors-final.csv
HHINCOME       = ../ICE/export/output/ice-hhincome.csv
COMBINED       = ../ICE/export/output/ice-combine.csv
MINORS_POP     = ../individual/census/export/output/pop-1-19-census-final.csv

# --- Output ---
OUT = output/ice-analysis-final.csv

all: $(OUT)

$(OUT): src/merge.R $(FIREARM_MINORS) $(HHINCOME) $(COMBINED) $(MINORS_POP)
	mkdir -p output
	Rscript --vanilla $<

clean:
	rm -f $(OUT)
