# This code reads and plots atmospheric sounding diagrams
# Code developed by Rodrigo Lustosa, Wed May 18 2022
# References:
#  coordinate system from: ALGORITHMS FOR GENERATING A SKEW-T, LOG P DIAGRAM AND 
#   COMPUTING SELECTED METEOROLOGICAL QUANTITIES - G. S, Stipanuk 1973
#   https://apps.dtic.mil/sti/pdfs/AD0769739.pdf
#  More details in:
#   https://www.cs.ubc.ca/~tmm/courses/cpsc533c-06-fall/projects/sancho/proposal/documents/Skew-T-Manual.pdf


# packages
library(tidyverse)
library(lubridate)

# directory and file names
dir_input  <- "input"
dir_output <- "output"
file_sounding <- "sounding.csv"


# functions ---------------------------------------------------------------

# diagram true x and y coordinates (won't be displayed)
coordY <- function(pres)
  return(-11.5*log10(pres) + 34.5)
coordX <- function(temp,pres)
  return(0.1408*temp - 10.53975*log10(pres) + 31.619223)



# read files --------------------------------------------------------------

# open file
file_path <- file.path(dir_input,file_sounding)
con <- file(file_path, "r")
# read sounding data
lines <- readLines(con, n = 2)
station <- str_remove(lines[1],"station: ")
date    <- str_remove(lines[2],"date: ")
sounding_data <- read_csv(file_path,skip=2)
# close file
close(con)
# merge all information into a list
sounding <- list(station=station,date=ymd_hm(date),sounding_data=sounding_data)


