# Authors:     LM
# Maintainers: LM
# Date: 26-feb-24
# ===========================================

# this code need the dataset from
# Merged --> with this dataset the analysis can be finished
# Analyzing rates of mortality in
# ICE income quintiles

# -- libs ---
if(!require(pacman))install.packages("pacman")
p_load(dplyr,
       data.table,
       here,
       tidycensus,
       sf,
       tidyr)

# args {{{
args <- list(input = here("ICE/income-race/merge/output/IceIncRace-geo-final.csv"))

# Import ICE data (new task to merge)fre
inc_race <- fread(args$input)

## Conclusion
# At this point, Q1 (0-7808) is basically measured with the first category after estimating 7808 from 10,0000 income pop
# Q5 (49300-828000) would be the lower limit of the adjusted category of household income $45k-49,999 
# and then we must add the other income cats. This cats would be hhinc49300 + hhinc10-hhinc16.
  
# Tengo que pensar mejor las cantidades totales de poblacion por tramo censal
# PORQUE TIENE que reflejar los ajusted de los intervalos 

# Verificar porque hhinc_total 

# 1. Calculate ICE 
# calculate the ICE for racialized economic segregation
inc_race <- inc_race %>% 
  mutate(
    hhinc_total = 
        hhinc_7808 + hhinc2 + hhinc3 + hhinc4 + hhinc5 + hhinc6 + hhinc7 + hhinc8 +
        hhinc_49300 + hhinc10 + hhinc11 + hhinc12 + hhinc13 + hhinc14 + hhinc15 + hhinc16,
    
    # Low income nonwhites
    people_deprived  = hhinc_7808_no_white,
    
    # High income whites
    people_afluent = 
        (hhinc_49300_white + hhinc_white_10 + hhinc_white_11 + hhinc_white_12
                      + hhinc_white_13 + hhinc_white_14 + hhinc_white_15 + hhinc_white_16),

    iceIncRace = 
      (people_afluent - people_deprived) / 
      hhinc_total) 


# 2. Divide ICE measures into Quintiles 
ice_inc_race <- inc_race %>%
  arrange(iceIncRace) %>%  # Ensure data is sorted by ICE
  mutate(ICEquintile = ntile(iceIncRace, 5))  # Divide into quintiles



# 3. Calculate mortality rates for each group of quintiles of ICE (Q1,Q2,Q3,Q4,Q5)
ice_inc_race %>%
  group_by(ICEquintile) %>% 
 # filter(!is.na(ICEquintile)) %>% 
  summarise(child_rip = sum(RIP),
            total_pop = sum(pop_total),    
            rate = round((child_rip / total_pop) * 100000, 2)) 



