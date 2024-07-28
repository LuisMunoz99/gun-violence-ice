# Updating racial and poverty spatial analysis
# Authors:     LM
# Maintainers: LM
# Date: 18-Oct-23
# ===========================================

# libs
if(!require(pacman))install.packages("pacman")
p_load(data.table,
       here,
       sf,
       dplyr)

# Useful function 


# args {{{
args <- list(input1 = here("concentration-ind/import/output/IncRaceBasedCensus.csv"),
             input2 = here("concentration-ind/geocode/output/geocoded-coords.csv"),
             output = here("concentration-ind/merge/output/fatal-victims-final.csv"))
# }}}



# Import
census <- fread(args$input1)
fatal_uf <- fread(args$input2)


# Merging data 
out <- census %>% 
  left_join(fatal_uf, by = "GEOID") %>% 
  mutate(Count = if_else(is.na(Count), 0, Count))






# Output
write.csv(out,args$output, row.names = FALSE)






