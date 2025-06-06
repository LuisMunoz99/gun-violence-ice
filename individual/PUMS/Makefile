# Makefile: Master PUMS data
# Location: individual/PUMS/
# Author: LMN

.PHONY: all import quintiles symlinks clean

quintiles = hhinc-quintiles/output/hhinc-quintiles.csv
import = import/output/pums-hhinc.csv

all: $(import) $(quintiles) symlinks


symlinks:
	@mkdir -p export/output
	ln -sf $(abspath $(import)) export/output/pums-hhinc.csv
	ln -sf $(abspath $(quintiles)) export/output/hhinc-quintiles.csv

$(quintiles):
	$(MAKE) -C hhinc-quintiles

$(import):
	$(MAKE) -C import

clean:
	$(MAKE) -C import clean
	$(MAKE) -C hhinc-quintiles clean
	rm -f export/output/*

