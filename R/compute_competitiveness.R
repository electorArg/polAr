#'Competitividad  (\emph{Competitiveness})

#'@description
#'Funcion que devuelve un valor entre 0 y 1 que describe el grado de competencia de una eleccion en un distrito determinado  
#' (\emph{Function that returns a value between 0 and 1 that describes the degree of competition of an election in a given district})
#'@param data un tibble guardado como objeto en el Enviroment luego de consultar \code{\link{get_election_data}} 
#' (\emph{A tibble saved as an object in the Enviroment after querying \code{\link{get_election_data}}}).
#'@param level un character que establece el nivel de desagregacion sobre el que se quiere calcular la competitividad: 
#' por defualt es \code{provincia} y se desagregan las observaciones asignando los valores \code{departamento} o \code{circuito} al parametro
#' (\emph{Establishes the level of aggregation on which you want to compute competitiveness: by definition it is \code{provincia} 
#' and the observations are disaggregated by assigning the values \code{departamento} or \code{circuito} to the parameter}).
#'@details \eqn{Competitividad} mide la diferencia porcentual de votos válidos obtenidos por los dos partidos más votados \eqn{a} y \eqn{b}. 
#' Puede tomar valores entre \eqn{[0,1]} donde \eqn{1} es lo más comeptitivo (\eqn{a = 50\%} y \eqn{b = 50\%} de los votos).
#'  La fórmula utilizada es:  \deqn{Competitividad = 1 - (a - b)}
#'@details \strong{REQUISITO:} El formato de \code{data} debe ser \code{long} para calcular \code{\link{compute_competitiveness}}. 
#' Si \code{data} es \emph{wide} se puede transformar con \code{\link{get_long}} 
#' (\emph{\code{long} format of \code{data} is required for \code{\link{compute_competitiveness}}. If \code{data} is in \emph{wide} format
#' you can transform it with \code{\link{get_long}}}). 
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