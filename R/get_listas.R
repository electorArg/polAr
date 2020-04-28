#'Obtiene nombres de listas // Get party names

#'@description
#'Funcion que agrega el nombre de las listas o partidos como columna a un tibble obtenido con `election_get(data,long = TRUE)` //
#'Function that adds the name of the lists or parties as a column to a tibble obtained with `election_get (data, long = TRUE)`
#'@param data un tibble descargado con `election_get (data, long = TRUE)` guardado como objeto en el Enviroment // 
#' An `election_get (data, long = TRUE)` tibble saved as an object in the Enviroment
#'@export

get_lista <- function(data){
  
  
        x <- data %>% 
          dplyr::ungroup() %>% 
          dplyr::select(categoria, turno, anio) %>% 
          dplyr::distinct()
        
        
        categoria <- x$categoria
        
        turno <- x$turno  
        
        anio <- x$anio 
        

        listas_gh <- readr::read_csv(glue::glue('https://raw.githubusercontent.com/TuQmano/test_data/master/listas_', #CAMBIAR POR RUTA CORRECTA
                                          {categoria}, '_',  
                                          {turno}, 
                                          {anio}, '.csv')) %>% 
                      dplyr::rename(listas = vot_parCodigo, 
                                    codprov = vot_proCodigoProvincia, 
                                    nombre_lista = parDenominacion) 
          
        
       
        data %>% 
          dplyr::left_join(listas_gh)%>% 
          dplyr::mutate(nombre_lista = dplyr::case_when(
            is.na(nombre_lista) ~ listas, 
            T ~ nombre_lista
          ))
        }

