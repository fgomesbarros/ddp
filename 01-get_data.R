###############################################################################
#
# 01 - Get data files
#
###############################################################################

# Sets up enviroment
rm(list = ls())

# Sets url variables
gdp_url <- "ftp://ftp.ibge.gov.br/Pib_Municipios/2010_2013/base/base_txt.zip"
geo_url <- "ftp://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/localidades/Geomedia_MDB/BR_Localidades_2010_v1.mdb"

# Creates data dir
if(!file.exists("data")){
  dir.create("data")
}

# Download files
## GDP
download.file(url = gdp_url, destfile = "data/base.txt.zip")
unzip(zipfile = "data/base.txt.zip", exdir = "data")
file.remove("data/base.txt.zip")

## Geospatial data
download.file(url = geo_url, destfile = "data/BR_Localidades_2010_v1.mdb")
