# Makefile maestro para pipeline completo de regdem
# Autor: LMN

.PHONY: all import indicators export clean

# Corre todo el pipeline completo
all: import recode indicators export

# Cada etapa llama a su propio Makefile
export:
	$(MAKE) -C export

recode:
	$(MAKE) -C recode-ICD10

indicators:
	$(MAKE) -C indicators

import:
	$(MAKE) -C import

# Limpia todos los outputs generados
clean:
	$(MAKE) -C import clean
	$(MAKE) -C indicators clean
	$(MAKE) -C export clean
	$(MAKE) -C recode-ICD10 clean

