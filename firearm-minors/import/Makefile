# import/Makefile

# Paths
out = output/firearm-minors-2019-2022.csv
input = ../../individual/regdem/export/output/regdem2019-2022-final.csv

.PHONY: all clean

all: $(out)

$(out): src/assemble-firearm-minors.R $(input) 
	Rscript $<

clean:
	rm -f $(out)

