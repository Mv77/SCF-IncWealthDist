library(utils)

# root directory
root <- '.'

# Main web dir
web_root <- "https://www.federalreserve.gov/econres/files/"

# Years:
# We will be using variable "norminc", which
# was added in 1995.
years <- seq(1995,2019,3)

# The file suffixes are not necessarily contain the full year. Only
# decade-year for pre-2000.
sfxs <- sapply(years, function(x) as.character(ifelse(x < 2000, x %% 1e2, x)) )

for (i in 1:length(years)){
  
  year <- years[i]
  
  # Create the directory (will print out warning but won't overwrite
  # if it already exists)
  year_dir <- file.path(root,'data',year)
  dir.create(year_dir)
  
  # Download the "Summary extract" dataset in stata
  e_stata_file <- paste("scfp",year,"s.zip",sep ="")
  
  download.file(file.path(web_root,e_stata_file), 
                file.path(year_dir,e_stata_file), quiet = FALSE, mode = "wb")
  
  # Extract
  unzip(paste(year_dir,e_stata_file, sep = "/"), exdir = year_dir)
  
}