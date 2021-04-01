library(tidyverse)
library(haven)
library(forcats)

# Control panel ----

scf_dir <- "./data"

# Define the SCF variables that will be used as
# income, permanent income, and wealth.
inc_var      <- 'income'
perm_inc_var <- 'norminc'
wealth_var   <- 'networth'

# Load and pre-process SCF ----

# Find all the directories to check what years are in
dirs <- list.dirs(path = "./data/", full.names = FALSE, recursive = FALSE)

# And years (summary files don't have them as variables)
years <- as.numeric(dirs)

# Create a function that receives a year, reads the file
# and creates a variable indicating the year
read_and_label <- function(yr){
  
  filename <- file.path(scf_dir,yr,paste("rscfp",yr,'.dta', sep = ''))
  data <- read_dta(file = filename) %>%
    mutate(YEAR = yr)
  
  return(data)
  
}

# Read all years' summary files and paste them
SCF <- lapply(years, read_and_label) %>% bind_rows()


# Create income and wealth variables as indicated
SCF <- SCF %>%

  # Assign incomes and wealth, all in thousands
  mutate(Income     = .data[[inc_var]] * 1e-3,
         PermIncome = .data[[perm_inc_var]] * 1e-3,
         Wealth     = .data[[wealth_var]] * 1e-3) %>%
  
  # Create normalized wealth and log variables
  mutate(NrmWealth    = Wealth/PermIncome,
         lnWealth     = log(Wealth),
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
                             "NoHS"    = c("no high school diploma/GED"),
                             "HS"      = c("high school diploma or GED",
                                           "some college"),
                             "College" = c("college degree")))


# Discretize age into bins.
SCF <- SCF %>%
  mutate(Age_grp = cut(age, breaks = seq(15,95,5)))

# Export full normalized wealth dataset ----
# (useful for bootstrapping)

nrm_wealth <- SCF %>%
  select(YEAR, age, Age_grp, Educ, Wealth, PermIncome, NrmWealth, wgt) %>%
  setNames(c("wave","age","age_group","education",wealth_var,perm_inc_var,"wealth_income_ratio","weight")) %>%
  mutate(monetary_year = base_year)

write_csv(nrm_wealth, './wealth_income_ratio_full.csv')

# Sample restrictions ----

# Only keep those with positive wealth and positive permanent income,
# non-missing education level, age, or survey year
SCF <- SCF %>% filter(Wealth > 0,
                      PermIncome > 0) %>%
  drop_na(YEAR, Educ, Age_grp)


# Keep only the variables that will be used
SCF <- SCF %>%
  select(wgt, YEAR, Educ, Age_grp,
         lnWealth, lnNrmWealth, lnPermIncome)

# Delete all the intermediate objects
rm(list = setdiff(ls(), c('SCF','scripts_dir','base_year')))

library(ggplot2)
library(ggthemes)
p <- ggplot(SCF %>%
              filter(Age_grp %in% c("(20,25]","(25,30]",
                                    "(30,35]","(35,40]")),
            aes(x = lnPermIncome, y = lnNrmWealth)) +
  geom_density_2d() +
  facet_grid(Age_grp ~ Educ) +
  theme_bw()
print(p)

p <- ggplot(SCF %>% filter(YEAR == 1995) %>%
              filter(Age_grp %in% c("(20,25]","(25,30]",
                                    "(30,35]","(35,40]")),
            aes(x = lnNrmWealth, weight = wgt)) +
  geom_density() +
  facet_grid(Age_grp ~ Educ) +
  theme_bw()
print(p)