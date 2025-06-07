# export/Makefile

.PHONY: all clean

# Archivos de entrada y salida
OUT = output/firearm-minors-final.csv
SRC = src/merge.R
INPUT_IMPORT = ../import/output/firearm-minors-2019-2022.csv
INPUT_COORDS = ../geocode/spatial-join/output/firearm-minors-sf.csv

all: $(OUT)

$(OUT): src/merge.R $(INPUT_IMPORT) $(INPUT_COORDS)
	Rscript $<

clean:
	rm -f $(OUT)

