# Makefile maestro para pipeline completo de regdem
# Autor: LMN

.PHONY: all import indicators export clean

# Corre todo el pipeline completo
all: import indicators export

# Cada etapa llama a su propio Makefile
export:
	$(MAKE) -C export

indicators:
	$(MAKE) -C indicators

import:
	$(MAKE) -C import

# Limpia todos los outputs generados
clean:
	$(MAKE) -C import clean
	$(MAKE) -C indicators clean
	$(MAKE) -C export clean

