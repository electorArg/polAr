#'Obtiene nombres de listas // Get party names

#'@description
#'Funcion que agrega el nombre de las listas o partidos como columna a un tibble obtenido con `election_get(data,long = TRUE)` //
#'Function that adds the name of the lists or parties as a column to a tibble obtained with `election_get (data, long = TRUE)`
#'@param data un tibble descargado con `election_get (data, long = TRUE)` guardado como objeto en el Enviroment // 
#' An `election_get (data, long = TRUE)` tibble saved as an object in the Enviroment
#'@export

get_names <- function(data){
  

        x <- data %>% 
          dplyr::ungroup() %>% 
          dplyr::select(category, round, year) %>% 
          dplyr::distinct()
        
        
        category <- x$category
        
        round <- x$round  
        
        year <- x$year 
        

        listas_gh <- readr::read_csv(glue::glue('https://raw.githubusercontent.com/TuQmano/test_data/master/listas_', #CAMBIAR POR RUTA CORRECTA
                                          {category}, '_',  
                                          {round}, 
                                          {year}, '.csv')) %>% 
                      dplyr::rename(listas = vot_parCodigo, 
                                    codprov = vot_proCodigoProvincia, 
                                    nombre_lista = parDenominacion) 
          
        
       
        data %>% 
          dplyr::left_join(listas_gh, by = c('listas', 'codprov')) %>% 
          dplyr::mutate(nombre_lista = dplyr::case_when(
            is.na(nombre_lista) ~ listas, 
            T ~ nombre_lista
         
            
             ))
        }

