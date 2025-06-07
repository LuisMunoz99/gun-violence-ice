# --- File: Makefile ---
.PHONY: all assemble import clean

assemble = output/export-manual.xlsx
manual_done  = hand/export-manual-done.xlsx
coords = output/coordinates.csv

all: $(coords)

$(coords): src/import-manual.R $(manual-done)
	Rscript $<

$(assemble): src/assemble-manual.R
	Rscript $<

clean:
	rm -f $(assemble) $(coords)

