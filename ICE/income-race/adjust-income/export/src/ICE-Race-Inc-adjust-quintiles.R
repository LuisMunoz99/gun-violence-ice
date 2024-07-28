# Authors:     LM
# Maintainers: LM
# Date: 24-feb-24
# ===========================================

# Adjusting census household income data
# Based on upstream measure of incomes
# do i have to do this adjustment for race + income ICE? I think i dont have to so i have to verify that issue 

# -- libs ---
if (!require(pacman)) install.packages("pacman")
p_load(dplyr,
       data.table,
       here)

# args {{{
args <- list(input1 = here("ICE/income-race/import/output/IceIncWhiteCensus.csv"),
             input2 = here("ICE/income-race/adjust-income/measure-quintiles/output/HI-quintiles.csv"),
             hand = here("ICE/income-race/import/notes/IceIncWhiteVarsDic.txt"),
             output = here("ICE/income-race/adjust-income/export/output/IceIncRace-adjusted.csv"))

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


proportion_white_alone <- .43
proportion_no_white_alone <- .56

income_adjusted <- income_census %>%
  mutate(
    # Poor quintile
    hhinc_7808 = ((quintiles_PUMS$upper.limits[1] - 0) / 10000) * hhinc1,
    
    # High income start
         hhinc_49300 = ((49999 - quintiles_PUMS$upper.limits[4]) / 5000) * hhinc9,
    
    # Low income whites quintile
         hhinc_7808_white = (proportion_white_alone * (quintiles_PUMS$upper.limits[1] - 0) / 10000) * hhinc_white_1,
    
    # High income whites start
         hhinc_49300_white = (proportion_white_alone * (49999 - quintiles_PUMS$upper.limits[4]) / 5000) * hhinc_white_9,
    
    # Low income non whites quintile
         hhinc_7808_no_white = (proportion_no_white_alone * (quintiles_PUMS$upper.limits[1] - 0) / 10000) * hhinc_no_white_1,
    
    # High income whites start
         hhinc_49300_no_white = (proportion_no_white_alone * (49999 - quintiles_PUMS$upper.limits[4]) / 5000) * hhinc_no_white_9,
         ) 



## Conclusion
# At this point, Q1 (0-7808) is basically measured with the first category after estimating 7808 from 10,0000 income pop
# Q5 (49300-828000) would be the lower limit of the adjusted category of household income $45k-49,999 
# and then we must add the other income cats. This cats would be hhinc49300 + hhinc10-hhinc16.


# -- Output ---
fwrite(income_adjusted, args$output)

##  done (reviewed 3 july 2024)
