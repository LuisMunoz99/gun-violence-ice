# Authors:     LM
# Maintainers: LM
# Date: 24-feb-24
# ===========================================

# Adjusting census household income data
# Based on upstream measure of incomes 
# src: ice_inc/quintiles/src/HI-income-quintiles.R

## Que asumiremos distribucion uniforme? interpolar?


# -- libs ---
if(!require(pacman))install.packages("pacman")
p_load(dplyr,
       data.table,
       here)

# args {{{
args <- list(input1 = here("ICE/income/import/output/IceCensus.csv"),
             input2 = here("ICE/income/adjust-income/measure-quintiles/output/HI-quintiles.csv"),
             hand = here("ICE/income/import/notes/IceIncVarsDic.txt"),
             output = here("ICE/income/adjust-income/export/output/ICE-adjustedInc.csv"))


# -- Import ---
income_census <- fread(args$input1)
quintiles_PUMS <- fread(args$input2)
desc_vars_census <- read.table(args$hand, sep = "\t", header = TRUE)



# -- Adjust income vars ---

## Assuming uniform distribution 

## Quintile 1 (1st Quintile (0% - 20%), x <= 7808) 
# 2  B19001_002 hhinc1 household income <$10k
# hhinc_7808 = ((threshold - minimum value) / orig category) * total households in category
# Measure is based on the proportion and assumes uniform distribution 

## Quintiles 5 ()
# 10 B19001_010  hhinc9 household income $45k-49,999
# =((49999-48207)/5000)*total household from thecat
# =((Upperlimit in category - category of interest)/intervalo de precio)* total de households en la categoria
# = (Total households > 45,000) * ((Threshold - Minimum income) / (Maximum income - Minimum income))


# hhinc_49300 = ((Upperlimit in category - category of interest)/intervalo de precio) * total de households en la categoria
# Measure is based on the proportion that this income corresponds to the total category of income 




income_adjusted <- income_census %>% 
  mutate(hhinc_7808 = ((quintiles_PUMS$upper.limits[1] - 0)/10000) * hhinc1,
         hhinc_49300 = ((49999-quintiles_PUMS$upper.limits[4])/5000) * hhinc9) 


## Conclusion
# At this point, Q1 (0-7808) is basically measured with the first category after estimating 7808 from 10,0000 income pop
# Q5 (49300-828000) would be the lower limit of the adjusted category of household income $45k-49,999 
# and then we must add the other income cats. This cats would be hhinc49300 + hhinc10-hhinc16.


# -- Output ---
fwrite(income_adjusted, args$output)

## Final task will be used to create the Quintiles. 

