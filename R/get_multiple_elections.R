#' Descarga resultados de múltiples elecciones 
#'  (\emph{Download multiple election electoral data})
#'  
#' @description
#' Esta función permite descargar restultados de una multiplicidad de elecciones al mismo tiempo. 
#'  (\emph{Function that downloads multiple national electoral data with one call})
#'  
#' @param data  data.frame con tantas filas como elecciones se quiere descargar y cuatro columnas con las siguientes variables: \emph{district}, \emph{category}, \emph{round}, \emph{year} 
#'  (\emph{data.frame with as many rows as elections you want to download and four columns with the following variables:\emph{district}, \emph{category}, \emph{round}, \emph{year}}).
#'  
#' @param unnest  un boleano que devuelve los datos anidados cuando \code{TRUE} agrupando cada elección o un data.frame cuando es \code{FALSE} que incluye una variable de id de la elección
#'  (\emph{a boolean that returns nested data when \code{TRUE}, grouping each election or a data.frame when \code{FALSE} that includes an election id variable}).  
#'  
#' @return devuelve un tibble con \code{class "grouped_df", "tbl_df","tbl", "data.frame"} con los resultados de las eleccion seleccionadas, con tantas
#' filas como elecciones se consultaron y dos columnas: \emph{id} de la eleccion construido como concatenación de los parametros 
#' \code{year_category_round_year}; \emph{election} contiene un listado de tibbles con los resultados agregados a nivel provincial para cada elección
#'  (\emph{returns a tibble of \code{class "grouped_df", "tbl_df", "tbl", "data.frame"} with as many rows as elections requested and two columns: 
#'  \emph{id} of the election build as a concatenation of the parameters \code{year_category_round_year}; \emph{election} contains a list of tibbles with 
#'  electoral results aggregated at the provincial level for each each row}).
#' 
#' @examples 
#' 
#'  polAr::show_available_elections() %>% 
#'  dplyr::filter(district == "caba", 
#'               category == "dip",
#'               round == "paso") -> caba_paso_diputados
#'               
#' caba_paso_diputados
#'                
#'  get_multiple_elections(caba_paso_diputados)                    
#'  
#'@seealso  \code{\link{get_election_data}}     
#'  
#'  
#' @export


get_multiple_elections <- function(data, 
                                   unnest = FALSE){

  
# NEST ELECTIONS
    nested <- data %>% 
      dplyr::select(-NOMBRE) %>% 
      dplyr::mutate(id = glue::glue("{district}_{category}_{round}_{year}"), 
             year = as.integer(year)) %>%
      dplyr::group_by(id) %>% 
      tidyr::nest()
    
# ITERATE CALL FOR EVERY ELECTION ROW IN THE NESTED DATA FRAME  
      
  nested_election <-  nested %>% 
        dplyr::mutate(election = purrr::map2(.x = data, 
                                             .y = id,  
                                             ~ polAr::get_election_data(
                                                          district = .x$district,
                                                          category = .x$category,
                                                          round = .x$round,
                                                          year = .x$year)
                                                        )) 
 
       
       
       if(unnest == TRUE){
         
         
         nested_election %>% 
           dplyr::ungroup() %>% 
           tidyr::unnest(cols = c(election)) %>% 
           dplyr::select(-c(data))
         
         
         
         
       }else{ 
         
         
         nested_election %>% 
           dplyr::select(-c(data))
         
         }
        
}
