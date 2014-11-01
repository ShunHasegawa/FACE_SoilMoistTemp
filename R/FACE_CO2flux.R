##############################################
# Install/update HIE if you haven't done yet #
##############################################
# source("R/hivs.R")

#######################################
# download up to date files from HIEv #
#######################################
setToken(tokenfile = "Data/token.txt")

# download files from HIEv
# use chachefile function in downloadTOA5

fls <- searchHIEv("FACE.*co2")

allco2 <- downloadTOA5(filename = fls$filename[1], cachefile="Data/hievdata/tmp_co2.RData",
                         topath="Data/hievdata/row_data", maxnfiles = 600)
# previous files are stored in hievdata/tmp_co2.RData

# remove duplicates and add ring and co2 columns
allsoil <- processData(allsoils)
# Note: this will take some time...
