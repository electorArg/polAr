#' Secciones Electorales de PBA de utilidad para geofacet
#'
#' @name secciones_pba
#' @docType data
#' @author Juan Pablo Ruiz Nicolini 
#' @keywords data

secciones_pba <- readr::read_csv("https://raw.githubusercontent.com/electorArg/PolAr_Data/master/geo/secciones_pba.csv",  
                           col_types = readr::cols())

usethis::use_data(secciones_pba, overwrite = TRUE) 