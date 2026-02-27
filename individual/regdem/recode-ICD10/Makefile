# Makefile: regdem indicators pipeline
# Author: LMN

input = ../import/output/regdem2019-2022.csv
recode = output/cause-category.csv

all: $(recode)

$(recode): src/recode.R $(input) 
	Rscript --vanilla $<


clean:
	rm $(recode)

