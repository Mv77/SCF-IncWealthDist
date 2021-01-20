
scripts_dir <- "./scripts"

# Base year used for inflation adjustments. When a new
# SCF wave becomes public, the past summary files are
# retroactively adjusted. Please check what is the base
# year at the moment of running this script.
# This information is usually at
# https://www.federalreserve.gov/econres/scfindex.htm
# in section "Description of summary extract public data files".
base_year <- 2019

source(file.path(scripts_dir,'Download.R'))
source(file.path(scripts_dir,'Pre-process.R'))
source(file.path(scripts_dir,'Summ-stats.R'))