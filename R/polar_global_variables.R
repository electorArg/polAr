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
                                                        "year",
                                                        "codprov", 
                                                        "name_prov", 
                                                        "nombre_lista", 
                                                        "lista", 
                                                        "electores", 
                                                        "LaTex", 
                                                        "listas_fct", 
                                                        "NOMBRE", 
                                                        "coddepto", 
                                                        "totales", 
                                                        "dif", 
                                                        "group",
                                                        "coddept", 
                                                        "PARTY", 
                                                        "VOTES", 
                                                        "DIVISOR", 
                                                        "QUOTIENTS", 
                                                        "ORDER", 
                                                        "mesa", # Must fix data input SALTA Dip 
                                                        "anio", 
                                                        "president", 
                                                        "Presidente",
                                                        "id", 
                                                        "n", 
                                                        "word", 
                                                        "election", 
                                                        "seats_pct", 
                                                        "votes_pct", 
                                                        "index","full_geo_metadata", 
                                                        "codprov", 
                                                        "codprov_censo", 
                                                        "codprov_iso", 
                                                        "code", 
                                                        "name_prov", 
                                                        "name_iso", 
                                                        "coddepto", 
                                                        "coddepto_censo", 
                                                        "nomdepto_censo", 
                                                        "data",
                                                        "grillas_geofacet", 
                                                        "name_provincia"))






















