# ------------------------------------------
# Author: LMN
# Date: 2025-05-30
# ------------------------------------------


INPUTS = \
  input/regdem_2015-2020.xlsx \
  input/regdem2020.xlsx \
  input/regdem_2021_agosto2022.xlsx \
  input/regdem_2022.xlsx

OUTPUTS = \
  output/regdem2019.csv \
  output/regdem2020.csv \
  output/regdem2021.csv \
  output/regdem2022.csv \
  output/regdem2019-2022.csv

all: $(OUTPUTS)

$(OUTPUTS): $(INPUTS) src/import-regdem.R
	Rscript src/import-regdem.R

clean:
	rm -f output/regdem*.csv

