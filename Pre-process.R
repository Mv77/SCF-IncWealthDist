library(tidyverse)
library(haven)
library(forcats)

# Control panel ----

scf_dir <- "E:/Data/SCF/Processed"

# Define the SCF variables that will be used as
# income, permanent income, and wealth.
inc_var      <- 'income'
perm_inc_var <- 'norminc'
wealth_var   <- 'networth'

# Load and pre-process SCF ----

# Read
SCF <- read_dta(file.path(scf_dir,'SCF_FULL.dta')) %>%
  
  # Assign incomes and wealth
  mutate(Income     = .data[[inc_var]],
         PermIncome = .data[[perm_inc_var]],
         Wealth     = .data[[wealth_var]])

# Create normalized wealth and log variables
SCF <- SCF %>%
  
  mutate(NrmWealth    = Wealth/PermIncome,
         lnNrmWealth  = log(NrmWealth),
         lnPermIncome = log(PermIncome))

# Education level:
# Use `edcl` from the summary file, grouping
# HS graduates and "some college".
SCF <- SCF %>%
  
  # Original classification
  mutate(edcl = factor(edcl, levels = c(1,2,3,4),
                       labels = c("no high school diploma/GED",
                                  "high school diploma or GED",
                                  "some college",
                                  "college degree")
                       )
         ) %>%
  
  # Collapsed classification
  mutate(Educ = fct_collapse(edcl,
                             "NoHS"   = c("no high school diploma/GED"),
                             "HS"      = c("high school diploma or GED",
                                           "some college"),
                             "College" = c("college degree")))


# Discretize age into bins.
SCF <- SCF %>%
  mutate(Age_grp = cut(age, breaks = seq(15,100,5)))

# Sample restrictions ----

# Only keep those with positive wealth and positive permanent income,
# non-missing education level, age, or survey year
SCF <- SCF %>% filter(Wealth > 0,
                      PermIncome > 0) %>%
  drop_na(YEAR, Educ, Age_grp)

rm(list = setdiff(ls(), c('SCF','scripts_dir')))