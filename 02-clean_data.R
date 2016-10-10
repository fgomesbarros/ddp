###############################################################################
#
# 01 - Clean raw data 
#
###############################################################################

# Sets up enviroment
rm(list = ls())
require(Hmisc)
require(xlsx)
require(dplyr)

# Sets url variables
gdp_file <- "data/base.txt"
geo_file <- "data/BR_Localidades_2010_v1.mdb"

gdp_columns <- c("year", "state_id", "state_name", "county_id", "county_name",  
                 "GDP", "GPD_per_capita")

# Cleans gdp_data
gdp <- read.xlsx2(file = "data/base.xls", sheetIndex = 1, 
                  stringsAsFactors = FALSE)

## Filters columns
gdp <- gdp[, c(1:5, 17, 19)]
names(gdp) <- gdp_columns

## Filters rows
gdp <- gdp[gdp$state_id == "26" & gdp$year == "2013", ]

## Removes columns
gdp <- gdp[, c("county_id", "county_name", "GDP", "GPD_per_capita")]

## Converts data
gdp$county_id <- as.numeric(gdp$county_id)
gdp$GDP <- as.numeric(gdp$GDP)
gdp$GPD_per_capita <- as.numeric(gdp$GPD_per_capita)

# Cleans geospatial data
geospatial <- mdb.get(file = geo_file, tables = "BR_Localidades_2010_v1")

## Filters data
geospatial <- geospatial[geospatial$TIPO == "URBANO" 
                         & geospatial$CD.CATEGORIA == 1, ]
geospatial <- geospatial[, c("CD.GEOCODMU", "LONG", "LAT")]

## Converts data
geospatial$CD.GEOCODMU <- as.numeric(geospatial$CD.GEOCODMU)

# Joins data
df <- left_join(x = gdp, y = geospatial, by = c("county_id" = "CD.GEOCODMU"))
