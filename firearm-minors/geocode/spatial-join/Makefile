# spatial-join/Makefile

# Variables
out = output/firearm-minors-sf.csv

.PHONY: all clean

all: $(out)

$(out): src/coords-to-sf.R
	Rscript $<

clean:
	rm -f $(out)

