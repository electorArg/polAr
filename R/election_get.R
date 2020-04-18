#'Descarga de Bases de resultados electorales - nivel mesa
#'@description
#'Funcion que descarga bases de resultados electorales nacionales desde el año 2007
#'@param distrito un character con mobre con codigo para argentina y las 24 provincias
#'@param cargo un character para la categoria electoral - diputado, senador o presidente: dip , sen, presi
#'@param turno un integer para el anio de eleccion
#'@param tipo tipo de eleccion - primaria o general: paso, gral

election_get <- function(distrito,
                         categoria,
                         turno,
                         anio,
                         long = FALSE){

  if(long == TRUE){

  readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
                  distrito, "_",
                  categoria, "_",
                  turno,
                  anio, ".csv?raw=true")) %>%
      tidyr::pivot_longer(names_to = "listas",
                          values_to = "votos",
                          cols = c(6: length(.)))
  }else{

    readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
                           distrito, "_",
                           categoria, "_",
                           turno,
                           anio, ".csv?raw=true"))

    }
                                }
