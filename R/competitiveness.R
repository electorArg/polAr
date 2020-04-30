#'Competitividad // Competitiveness

#'@description
#'Funcion que devuelve un valor entre 0 y 1 que describe el grado de competencia de una eleccion en un distrito determinado // 
#'Function that returns a value between 0 and 1 that describes the degree of competition of an election in a given district
#'@param data un tibble guardado como objeto en el Enviroment luego de consultar `election_get()` // 
#'A tibble saved as an object in the Enviroment after querying `election_get ()`
#'@param level un character que establece el nivel de desagregacion sobre el que se quiere calcular la competitividad: por defualt es 'provincia' 
#'y se desagregan las observaciones asignando los valores 'departamento'  o 'circuito' al parametro. // 
#'Establishes the level of aggregation on which you want to compute competitiveness: by definition it is 'province' 
#'and the observations are disaggregated by assigning the values 'departamento' or 'circuito' to the parameter.
#'@export



compute_competitiveness <- function(data,
                       level = "provincia"){
  
  
  # Check parameters and data format
  
  assertthat::assert_that(level %in% c("provincia", "departamento", "circuito"), 
                          msg = glue::glue({level}," is not a valid level c('provincia', 'departamento', 'circuito')"))
                          
  assertthat::assert_that("listas" %in% colnames(data), 
                          msg = "data is not in a long format. Use 'get_long()' to transform it" )
  
  
  if(level == "departamento"){
  assertthat::assert_that("coddepto" %in% colnames(data), 
                          msg = "data input is not at the correct level. Donload it again with parameters: get_election_data(..., level = 'departamento)" )
  
  } else if (level == "circuito") { 
  assertthat::assert_that("circuito" %in% colnames(data), 
                          msg = "data input is not at the correct level. Download it again with parameters: get_election_data(..., level = 'circuito)" )
  }
  
  
  
   # CREO FUNCION TEMPORAL PARA DETERMINAR level DE AGREGACION DE LOS DATOS 

  # Temp function:  level selection
  
  levels <- function(level = ""){
    
    # Replace if_eses with case_when 
    dplyr::case_when(
      level == "provincia" ~ c("codprov"), 
      level == "departamento" ~ c("codprov, depto, coddepto"),
      level == "circuito" ~ c("codprov, depto, coddepto, circuito"), 
      T ~c("codprov")
    )}
  
  
  levels <- stringr::str_split(string = levels(level = level), pattern = "\\,")
  levels <- stringr::str_squish(levels[[1]])
  levels_lista <- c(levels, "listas")
  levels_unique <- c("codprov", "listas")
  
if(level != "provincia"){ 
  
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
