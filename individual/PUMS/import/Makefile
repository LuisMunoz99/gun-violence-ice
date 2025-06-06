# Makefile: PUMS import 
# Author: LMN

# Inputs
input = input/psam_h72.csv

# Outputs
import = output/pums-hhinc.csv

all: $(import) 

$(import): src/pums-hhinc-import.R $(input)
	Rscript --vanilla $<


clean:
	rm -f $(import)
