#'Competitividad

#'@description
#'Funcion que devuelve un valor entre 0 y 1 que describe el grado de competencia de una elección en un distrito determinado
#'@param data un tibble guardado como objeto en el Enviroment luego de consultar `election_get()`
#'@param nivel establece el nivel de desagregación sobre el que se quiere calcular la competitividad: 'provincial' mostrará detalle al interior del distrito. 'departmantal'  lo hará al nicel de circuitos electorales. 
#'@export



competitividad <- function(data,
                           nivel  = "distrito"){
  
  # CREO FUNCION TEMPORAL PARA DETERMINAR NIVEL DE AGREGACION DE LOS DATOS 
  levels <- function(nivel){
   
    if(nivel == "distrito")
     
      c("")
   
    else if(nivel == "departamento"){
 
      c("codprov, depto, coddepto")
      
    }else if(nivel == "circuito"){
      c("codprov, depto, coddepto, circuito")
      }
    }
    
  
  levels <- stringr::str_split(string = levels(nivel = nivel), pattern = "\\,")
  levels <- stringr::str_squish(levels[[1]])
  levels_lista <- c(levels, "listas")
  levels_unique <- c("codprov", "listas")
  
if(nivel != "distrito"){ 
  
  temp <-  data %>%
    dplyr::group_by_at(levels_lista) %>% 
    dplyr::summarise_at(.vars = c("votos"), .funs = sum) %>% 
    dplyr::mutate(votos = votos/sum(votos)) %>% 
    dplyr::top_n(n = 2, wt = votos) %>%   
    dplyr::arrange(dplyr::desc(votos)) %>% 
    dplyr::mutate(competitividad = 1 - (votos - dplyr::lead(votos))) %>% 
    dplyr::slice(1) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(-c(listas, votos)) %>%   
    dplyr::arrange(levels_lista)
  
   
}
  else{
    
    temp <-  data %>%
      dplyr::group_by_at(levels_unique) %>% 
      dplyr::summarise_at(.vars = c("votos"), .funs = sum) %>% 
      dplyr::mutate(votos = votos/sum(votos)) %>% 
      dplyr::top_n(n = 2, wt = votos) %>%   
      dplyr::arrange(dplyr::desc(votos)) %>% 
      dplyr::mutate(competitividad = 1 - (votos - dplyr::lead(votos))) %>% 
      dplyr::slice(1) %>% 
      dplyr::ungroup() %>% 
      dplyr::select(-c(listas, votos))%>%   
      dplyr::arrange(levels_unique)
    
    
    
  }
  
  temp
    
}





