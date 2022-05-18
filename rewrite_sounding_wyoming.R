# This code reads soundings copied from University of Wyoming webpage and saves
# as standardized format
# webpage: http://weather.uwyo.edu/upperair/sounding.html
# Code developed by Rodrigo Lustosa, Wed May 18 2022

# packages
library(tidyverse)
library(lubridate)

# directory and file names
dir_soundings  <- "input"
file_input  <- "sounding_wyoming.txt"
file_output <- "sounding.csv"



# read input --------------------------------------------------------------

# open file
file_path <- file.path(dir_soundings,file_input)
con <- file(file_path, "r")
# extract sounding basic info
lines <- readLines(con, n = 7)
info_line_2 <- str_split(lines[2], " Observations at ")[[1]]
header <- str_split(lines[5], " +")[[1]][-1]
date <- dmy_h(str_c(str_sub(info_line_2[2],5)," ",str_sub(info_line_2[2],1,2)))
station <- info_line_2[1]
# count levels
line <- readLines(con, n = 1)
n_levels <- 0
while(line != ""){
  n_levels <- n_levels + 1
  line <- readLines(con, n = 1)
}
# close file
close(con)
# read data
sounding_data <- read_fwf(file_path,skip = 7,n_max=n_levels)
names(sounding_data) <- header
# change temperature unit to Kelvin
sounding_data$TEMP <- sounding_data$TEMP + 273.15
sounding_data$DWPT <- sounding_data$DWPT + 273.15
# merge all information into a list
sounding <- list(station=station,date=date,sounding_data=sounding_data)



# save output -------------------------------------------------------------

# open file
file_path <- file.path(dir_soundings,file_output)
con <- file(file_path, "w")
# write data
write(paste(names(sounding)[1],sounding[[1]],sep=": "),con)
write(paste(names(sounding)[2],format(sounding[[2]],"%Y-%m-%d %H:%M UTC"),sep=": "),con)
write(paste(names(sounding$sounding_data),collapse = ","),con)
for (i in 1:n_levels)
  write(paste(sounding$sounding_data[i,],collapse = ","),con)
# close file
close(con)

