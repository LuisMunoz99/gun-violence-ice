# geocode/Makefile

.PHONY: all clean

all: export/output/firearm-minors-sf.csv

coords/output/coordinates.csv:
	$(MAKE) -C coords output/coordinates.csv

spatial-join/output/firearm-minors-sf.csv: coords/output/coordinates.csv
	$(MAKE) -C spatial-join output/firearm-minors-sf.csv

export/output/firearm-minors-sf.csv: spatial-join/output/firearm-minors-sf.csv
	mkdir -p export/output
	ln -sf ../../spatial-join/output/firearm-minors-sf.csv $@

clean:
	$(MAKE) -C coords clean
	$(MAKE) -C spatial-join clean
	rm -f export/output/firearm-minors-sf.csv

