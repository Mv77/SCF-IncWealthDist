library(srvyr)


# Summary statistics ----

# Create survey object, and group it.
scf_srvy <- as_survey_design(SCF, weights = 'WEIGHT')

# Define groupings
groupings <- list(c("Educ", "YEAR", "Age_grp"),
                  c("YEAR", "Age_grp"),
                  c("Educ", "Age_grp"),
                  c("Educ", "YEAR"),
                  c("Educ"), c("YEAR"), c("Age_grp"))

# An auxiliary function that finds the quantities of
# interest at any grouping
calcSumStats <- function(survey, grouping){
  
  # Find number of observations used for stats
  sumstats <- survey %>% group_by_at(grouping) %>%
    srvyr::summarise(
      
      # Weighted and unweighted number of observations.
      w.obs = survey_total(),
      obs   = unweighted(n()),
      
      # Mean and sd of log(Wealth/Permanent income)
      lnNrmWealth.mean = survey_mean(lnNrmWealth),
      lnNrmWealth.sd   = survey_sd(lnNrmWealth),
      
      # Mean and sd of log(Permanent income)
      lnPermIncome.mean = survey_mean(lnPermIncome),
      lnPermIncome.sd   = survey_sd(lnPermIncome)
      
    ) %>%
    select(-contains("_se")) 
  
  return(sumstats)
  
}

# Apply to all groupings and combine into single table.
table <- lapply(groupings, function(grp) calcSumStats(scf_srvy, grp)) %>%
  bind_rows()

# Export result
write_csv(table,
          file.path(scripts_dir,'WealthIncomeStats.csv'))