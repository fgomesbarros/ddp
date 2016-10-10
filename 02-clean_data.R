###############################################################################
#
# 01 - Clean raw data 
#
###############################################################################

# Sets up enviroment
rm(list = ls())
require(Hmisc)
require(xlsx)

# Sets url variables
gdp_file <- "data/base.txt"
geo_file <- "data/BR_Localidades_2010_v1.mdb"

gdp_columns <- c("year", "state_id", "state_name", "county_id", "county_name",  
                 "GDP", "GPD_per_capita")

# Cleans gdp_data
gdp <- read.xlsx2(file = "data/base.xls", sheetIndex = 1, 
                  stringsAsFactors = FALSE)
gdp <- gdp[, c(1:5, 17, 19)]
names(gdp) <- gdp_columns

## Filters rows
gdp <- gdp[gdp$state_id == "26" & gdp$year == "2013", ]

## Removes columns
gdp <- gdp[, c("county_id", "county_name", "GDP", "GPD_per_capita")]

## Converts values
gdp$county_id <- as.numeric(gdp$county_id)
gdp$GDP <- as.numeric(gdp$GDP)
gdp$GPD_per_capita <- as.numeric(gdp$GPD_per_capita)