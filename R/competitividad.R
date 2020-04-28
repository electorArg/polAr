#'Competitividad // Competitiveness

#'@description
#'Funcion que devuelve un valor entre 0 y 1 que describe el grado de competencia de una eleccion en un distrito determinado // 
#'Function that returns a value between 0 and 1 that describes the degree of competition of an election in a given district
#'@param data un tibble guardado como objeto en el Enviroment luego de consultar `election_get()` // 
#'A tibble saved as an object in the Enviroment after querying `election_get ()`
#'@param nivel establece el nivel de desagregacion sobre el que se quiere calcular la competitividad: por defualt es 'provincia' y se desagregan las observaciones asignando los valores 'departmento'  o 'circuito' al parametro. // 
#'Wstablishes the level of disaggregation on which you want to calculate competitiveness: by definition it is 'province' and the observations are disaggregated by assigning the values 'department' or 'circuit' to the parameter.
#'@export



competitive<- function(data,
                           nivel = "provincia"){
  
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
  levels_lista <- c(levels, "listas")
  levels_unique <- c("codprov", "listas")
  
if(nivel != "provincia"){ 
  
  temp <-  data %>%
    dplyr::group_by_at(levels_lista) %>% 
    dplyr::summarise_at(.vars = c("votos"), .funs = sum) %>% 
    dplyr::mutate(votos = votos/sum(votos)) %>% 
    dplyr::top_n(n = 2, wt = votos) %>%   
    dplyr::arrange(dplyr::desc(votos)) %>% 
    dplyr::mutate(competitividad = 1 - (votos - dplyr::lead(votos))) %>% 
    dplyr::slice(1) %>% 
    dplyr::ungroup() %>% 
    dplyr::select(-c(listas, votos))    
  
   
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
      dplyr::select(-c(listas, votos))
    
    
    
  }
  
  temp
    
}





