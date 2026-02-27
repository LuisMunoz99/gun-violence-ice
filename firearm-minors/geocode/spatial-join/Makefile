# spatial-join/Makefile

# Variables
# Variables
out = output/firearm-minors-sf.csv
coords = ../coords/output/coordinates.csv

.PHONY: all clean

all: $(out)

$(out): src/coords-to-sf.R $(coords)
	Rscript $<

clean:
	rm -f $(out)

