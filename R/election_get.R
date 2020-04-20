#'Descarga de Bases de resultados electorales - nivel mesa

#'@description
#'Funcion que descarga bases de resultados electorales nacionales desde el año 2007
#'@param distrito un character con mobre con codigo para argentina y las 24 provincias
#'@param categoria un character para la categoria electoral - diputado, senador o presidente: dip , sen, presi
#'@param anio un integer para el anio de eleccion
#'@param turno tipo de eleccion - primaria o general: paso, gral
#'@param long estructura de los datos. Por default ´long´ == FALSE 



#'@export

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
                          cols = c(7: length(.))) %>% 
      dplyr::mutate(categoria = categoria,
             turno = turno, 
             anio = anio)
  }else{

    readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
                           distrito, "_",
                           categoria, "_",
                           turno,
                           anio, ".csv?raw=true")) %>% 
      dplyr::mutate(categoria = categoria,
             turno = turno, 
             anio = anio)

    }
                                }
