#'Obtener nombres de listas

#'@description
#'Funcion que agrega el nombre de las listas a un data.frame obtenido con `election_get()`
#'@param data un data.frame guardado como objeto en el Enviroment luego de consultar `election_get()` habiendo seleccionado parametro `long = TRUE`
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

