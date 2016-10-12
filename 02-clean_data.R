###############################################################################
#
# 01 - Clean raw data 
#
###############################################################################

# Sets up enviroment
rm(list = ls())
require(Hmisc)
require(gdata)
require(dplyr)

# Sets url variables
gdp_file <- "data/base.txt"
geo_file <- "data/BR_Localidades_2010_v1.mdb"

gdp_columns <- c("year", "state_id", "state_name", "county_id", "county_name",  
                 "GDP", "GDP_per_capita")

# Reads GDP data
gdp <- read.xls(xls = "data/base.xls", sheet = 1, stringsAsFactors = FALSE, 
                encoding = "latin1", dec = ",")

# Cleans GDP data
## Filters columns
gdp <- gdp[, c(1:5, 17, 19)]
names(gdp) <- gdp_columns

## Filters rows and colunms
gdp <- gdp %>%
    filter(state_id == "26" & year == "2013") %>%
    select(county_id, county_name, GDP, GDP_per_capita) %>%
    mutate(county_id = as.numeric(county_id)) %>% 
    mutate(GDP = gsub(pattern = ",", replacement = "", x = GDP)) %>%
    mutate(GDP = as.numeric(GDP)) %>%
    mutate(GDP_per_capita = gsub(pattern = ",", replacement = "", 
                                 x = GDP_per_capita)) %>%
    mutate(GDP_per_capita = as.numeric(GDP_per_capita))
  
# Cleans geospatial data
geospatial <- mdb.get(file = geo_file, tables = "BR_Localidades_2010_v1")

## Filters data
geospatial <- geospatial %>%
  filter(TIPO == "URBANO" & CD.NIVEL == 1) %>%
  select(CD.GEOCODMU, LONG, LAT) %>%
  mutate(CD.GEOCODMU = as.numeric(CD.GEOCODMU)) %>%
  mutate(LONG = as.numeric(LONG)) %>%
  mutate(LAT = as.numeric(LAT))

# Joins data
df <- left_join(x = gdp, y = geospatial, by = c("county_id" = "CD.GEOCODMU"))

# To lower column names
names(df)[5:6] <- tolower(names(df)[5:6])

# Saves on disk
write.csv2(x = df, file = "data/gdp_geo.csv", row.names = FALSE)