# Auditoría de Riesgos de Integridad (Read-Only)

Estado: Planificación. Este documento lista riesgos a verificar uno por uno sin modificar el proyecto.

## 🔴 Result-Integrity Risks
- [ ] `merge/src/merge.R` — Posible distorsión de conteos por `GEOID` si hay duplicados o asignaciones erróneas; afecta `merge/output/ice-analysis-final.csv`.
- [ ] `models/merge/src/merge.R` — Agregación por `GEOID` sin validación de integridad; afecta `models/merge/output/deaths-ct.csv` y modelos NB.
- [ ] `individual/regdem/export/src/merge.R` — `left_join` por `ControlNumber` puede mezclar o duplicar clasificaciones; afecta `individual/regdem/export/output/regdem2019-2022-final.csv`.
- [ ] `merge/src/merge.R` — `firearm_minor = ind_firearm & ind_minor` puede producir `NA`; `sum(..., na.rm=TRUE)` subcuenta sin aviso; afecta `merge/output/ice-analysis-final.csv`.
- [ ] `models/analysis/src/analysis-nb-ice.R` — Conversión a factor de `ICE_hhinc_quintile` sin validar `NA`/niveles; puede excluir datos silenciosamente y sesgar `excess-mortality-results.csv`.

## 🟠 Data Loss Risks
- [ ] `individual/regdem/import/src/import-regdem.R` — Parseo de fechas + filtro por año puede excluir filas silenciosamente; `distinct(ControlNumber)` elimina duplicados válidos.
- [ ] `individual/regdem/indicators/minor/src/ind-minor.R` — Filtro de `AgeUnit` puede excluir casos válidos no normalizados.
- [ ] `firearm-minors/import/src/assemble-firearm-minors.R` — Requiere `ind_minor` y `ind_firearm`; cualquier `NA` excluye registros sin aviso.
- [ ] `firearm-minors/export/src/merge.R` — `stop()` si >1 `ControlNumber` sin `GEOID`; puede abortar pipeline.

## 🟡 Classification Risks
- [ ] `individual/regdem/recode-ICD10/src/recode.R` — Regex simplificadas pueden clasificar mal ICD‑10 con formatos no estándar.
- [ ] `individual/regdem/indicators/firearm/src/ind-firearm.R` — Regla mixta (ICD‑10 + texto) puede generar falsos positivos/negativos.
- [ ] `individual/regdem/indicators/firearm/src/ind-firearm.R` — Dependencia de `DeathCause_I_Desc` (texto libre) puede introducir sesgo por idioma/abreviaturas locales.
- [ ] `individual/regdem/indicators/minor/src/ind-minor.R` — Cálculo de menores depende de `Age`/`AgeUnit`; riesgo de exclusión silenciosa.

## 🟣 Spatial Risks
- [ ] `firearm-minors/geocode/spatial-join/src/coords-to-sf.R` — Posible inversión lat/lon en `st_as_sf(coords = c("latitude","longitude"))`.
- [ ] `firearm-minors/geocode/spatial-join/src/coords-to-sf.R` — CRS/transformaciones sin verificación de consistencia; puntos fuera de tractos generan `GEOID` `NA`.
- [ ] `firearm-minors/geocode/spatial-join/src/coords-to-sf.R` — Filtro `!is.na(latitude)|!is.na(longitude)` permite puntos con una sola coordenada; riesgo de geometrías inválidas.
- [ ] `firearm-minors/geocode/coords/src/import-manual.R` — Coordenadas manuales a numérico pueden producir `NA`.
- [ ] `firearm-minors/geocode/coords/src/import-manual.R` — `distinct(ControlNumber, latitude, longitude)` puede eliminar registros múltiples por `ControlNumber` sin criterio temporal.

## ⚫ Temporal Risks
- [ ] `models/import/src/import-census.R` — ACS 2022 (5‑year) usado con mortalidad 2019–2022; posible desalineación temporal.
- [ ] `models/import/src/import-census.R` — Comentarios indican 2021 pero se usa 2022; riesgo de documentación engañosa sobre denominadores.
- [ ] `merge/src/merge.R` — Mezcla mortalidad 2019–2022 con denominadores ICE/ACS de año distinto.
- [ ] `ICE/hhincome/src/ice-value.R` y `ICE/combine/src/ice-value.R` — Dependencia en outputs de census sin validar año.

## Comandos sugeridos (NO EJECUTAR AHORA)
- [ ] `make -C individual`
- [ ] `make -C ICE`
- [ ] `make -C firearm-minors`
- [ ] `Rscript --vanilla merge/src/merge.R`
- [ ] `Rscript --vanilla models/import/src/import-census.R`
- [ ] `Rscript --vanilla models/merge/src/merge.R`
- [ ] `Rscript --vanilla models/eval/src/eval-nb-ice.R`
