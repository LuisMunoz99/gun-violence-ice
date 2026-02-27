
regdem = ../import/output/regdem2019-2022.csv
indicators = ../indicators/export/output/indicators.csv
recode = ../recode-ICD10/output/cause-category.csv

# Output path
output = output/regdem2019-2022-final.csv


# Main rule
all: $(output)

$(output): src/merge.R $(regdem) $(indicators) $(recode) 
	Rscript --vanilla  $<

# Limpieza
clean:
	rm -f $(output)

