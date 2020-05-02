#' \code{polAr} package
#'
#' Caja de Herramientas para el procesamiento de datos electorales de Argentina
#' See the README on
#' \href{https://github.com/electorArg/polAr/blob/master/README.md}{Github}
#'
#' @docType package
#' @name polAr
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines

if(getRversion() >= "2.15.1")  utils::globalVariables(c(".", 
                                                        "blancos", 
                                                        "nulos", 
                                                        "pct", 
                                                        "votos", 
                                                        "V1", 
                                                        "name", 
                                                        "turno", 
                                                        "depto", 
                                                        "circuito", 
                                                        "listas", 
                                                        "parDenominacion", 
                                                        "vot_parCodigo",
                                                        "vot_proCodigoProvincia", 
                                                        "distrito", 
                                                        "district", 
                                                        "category",
                                                        "round", 
                                                        "year")) # elimina nota al hacer build

