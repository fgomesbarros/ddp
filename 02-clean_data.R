###############################################################################
#
# 01 - Clean raw data 
#
###############################################################################

# Sets up enviroment
rm(list = ls())
require(gdata)
require(Hmisc)
require(dplyr)

# Sets url variables
gdp_file <- "data/base.txt"
geo_file <- "data/BR_Localidades_2010_v1.mdb"

gdp_cols <- c("reference_year", "state_id", "state_name", "municipality_id", 
              "municipality_name", "metropolitan_region", "mesoregion_id", 
              "mesoregion_name", "microregion_id", "microregion_name", 
              "agriculture_gva", "industry_gva", "service_gva", "pub_admin_gva", 
              "total_gva", "taxes_minus_subsidies", "gdp", "population", 
              "gdp_per_capita")

# Reads gdp data
gdp <- read.xls(xls = "data/base.xls", sheet = 1, stringsAsFactors = FALSE, 
                encoding = "latin1", dec = ",", col.names = gdp_cols)

# Cleans gdp data
## Converts char to numeric
as.currency <- function(value) {
    currency <- gsub(pattern = ",", replacement = "", x = value)
    currency <- as.numeric(currency)
    return(currency)
}

gdp <- gdp %>%
    mutate(municipality_id = as.numeric(municipality_id)) %>%
    mutate(mesoregion_id = as.numeric(mesoregion_id)) %>%
    mutate(microregion_id = as.numeric(microregion_id)) %>%
    mutate(agriculture_gva = as.currency(agriculture_gva)) %>%
    mutate(industry_gva = as.currency(industry_gva)) %>%
    mutate(service_gva = as.currency(service_gva)) %>%
    mutate(pub_admin_gva = as.currency(pub_admin_gva)) %>%
    mutate(total_gva = as.currency(total_gva)) %>%
    mutate(taxes_minus_subsidies = as.currency(taxes_minus_subsidies)) %>%
    mutate(gdp = as.currency(gdp)) %>%
    mutate(population = as.currency(population)) %>%
    mutate(gdp_per_capita = as.currency(gdp_per_capita))

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
df <- left_join(x = gdp, y = geospatial, 
                by = c("municipality_id" = "CD.GEOCODMU"))
 
# To lower column names
names(df) <- tolower(names(df))

# Saves on disk
write.csv2(x = df, file = "data/gdp_geo.csv", row.names = FALSE)