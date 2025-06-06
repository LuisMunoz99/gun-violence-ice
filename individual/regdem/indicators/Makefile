# Makefile: regdem indicators pipeline
# Author: LMN

input = ../import/output/regdem2019-2022.csv
firearm = firearm/output/firearm.csv
minor = minor/output/minor.csv
indicators = export/output/indicators.csv

all: $(indicators)

$(indicators): export/src/merge-indicators.R $(firearm) $(minor) 
	Rscript --vanilla export/src/merge-indicators.R

$(minor): minor/src/ind-minor.R $(input) 
	Rscript --vanilla minor/src/ind-minor.R

$(firearm): firearm/src/ind-firearm.R $(input) 
	Rscript --vanilla firearm/src/ind-firearm.R

# Limpieza de archivos generados
clean:
	rm $(indicators) $(minor) $(firearm) 

