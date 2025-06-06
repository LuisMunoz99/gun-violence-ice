
regdem = ../import/output/regdem2019-2022.csv
indicators = ../indicators/export/output/indicators.csv

# Output path
output = output/regdem2019-2022-final.csv


# Main rule
all: $(output)

$(output): src/merge.R $(regdem) $(indicators)
	Rscript --vanilla  $<

# Limpieza
clean:
	rm -f $(output)

