#' Resultados Electorales: Provincia de TUCUMAN, Diputado Nacional, Eleccion General 2017
#'
#'@name names
#'@docType data
#'@author Juan Pablo Ruiz Nicolini 
#'@keywords data

## code to prepare `tucuman_dip_gral_2017` dataset goes here

library(polAr)

tucuman_dip_gral_2017 <- get_election_data(district = "tucuman", 
                                           category = "dip", 
                                           round = "gral",
                                           year = 2017)

usethis::use_data(tucuman_dip_gral_2017,overwrite = TRUE)
