#'Obtiene nombres de listas (\emph{Get party names})

#'@description
#'Funcion que agrega el nombre de las listas o partidos como columna a un tibble obtenido con \code{\link{get_election_data}(long = TRUE)} 
#' (\emph{Function that adds party labels as a column to a tibble obtained with \code{\link{get_election_data}(long = TRUE)}})
#'@param data un tibble descargado con \code{\link{get_election_data}(long = TRUE)} guardado como objeto en el Enviroment  
#' (\emph{An \code{\link{get_election_data}(long = TRUE)} tibble saved as an object in the Enviroment})
#'@details \strong{REQUISITO:} El formato de \code{data} debe ser \code{long} para poder obtener 
#' nombres de listas con \code{\link{get_names}}. Si \code{data} es \emph{wide} se puede transformar con \code{\link{get_long}} 
#' (\emph{\code{long} format of \code{data} is required to get party labels with \code{\link{get_names}}.  If \code{data} is in
#' \emph{wide} format you can transform it with \code{\link{get_long}}}).   
#'@export

get_names <- function(data){
  
  # chek data format - LONG needed
  
  assertthat::assert_that("listas" %in% colnames(data), 
                          msg = "data is not in a long format. Use 'get_long()' to transform it" )
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

