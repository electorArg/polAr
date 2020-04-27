#'Descarga de Bases de resultados electorales - nivel mesa

#'@description
#'Funcion que descarga bases de resultados electorales nacionales desde el año 2007
#'@param distrito un character con mobre con codigo para argentina y las 24 provincias
#'@param categoria un character para la categoria electoral - diputado, senador o presidente: dip , sen, presi
#'@param anio un integer para el anio de eleccion
#'@param turno tipo de eleccion - primaria o general: paso, gral
#'@param nivel es un character para seleccionar nivel de agregación de los resultados: provincial, departamental o circuitos electorales 
#'@param long estructura de los datos. Por default ´long´ == FALSE 



#'@export

election_get <- function(distrito,
                         categoria,
                         turno,
                         anio,
                         nivel = "provincia",
                         long = FALSE){
  
        # CREO FUNCION TEMPORAL PARA DETERMINAR NIVEL DE AGREGACION DE LOS DATOS 
               levels <- function(nivel = ""){
                 
                 if(nivel == "provincia")
                   
                   c("codprov")
                 
                 else if(nivel == "departamento"){
                   c("codprov, depto, coddepto")
                   
                 }else if(nivel == "circuito"){
                   c("codprov, depto, coddepto, circuito")
                   
                 }else{
                   c("codprov")
                 }
                 
               }
               
              levels <- stringr::str_split(string = levels(nivel = nivel), pattern = "\\,")
              levels <- stringr::str_squish(levels[[1]])
              levels_long <- c(levels, "listas")
              
  

  if(long == TRUE){
    
   

  readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
                  distrito, "_",
                  categoria, "_",
                  turno,
                  anio, ".csv?raw=true")) %>%
      tidyr::pivot_longer(names_to = "listas",
                          values_to = "votos",
                          cols = c(dplyr::matches("\\d$"), blancos, nulos)) %>%
       dplyr::group_by_at(levels_long) %>% 
      dplyr::summarise_at(.vars = c("votos", "electores"), .funs = sum) %>% 
      dplyr::mutate(categoria = categoria,
             turno = turno, 
             anio = anio)
  }else{

    readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
                           distrito, "_",
                           categoria, "_",
                           turno,
                           anio, ".csv?raw=true")) %>% 
      dplyr::group_by_at(levels) %>% 
      dplyr::summarise_if(is.numeric, .funs = sum) %>% 
      dplyr::mutate(categoria = categoria,
             turno = turno, 
             anio = anio)

    }
                                }
