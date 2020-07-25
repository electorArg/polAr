#' Calcula Desproporción del Sistema de Partidos 
#'  (\emph{Computes Party System Disproportion})
#'  
#' @description
#' Función que calcula el índice de desprorpoción del sistema de partidos midiendo la distancia relativa entre proporción de votos
#' y de bancas obtendios por los partidos políticos (Gallagher por defecto)
#'  (\emph{Function that computes the party system disproportion index})
#'  
#' @param data la base de datos para hacer el cálculo obtenida con \code{\link{get_election_data}} 
#'  (\emph{tiblle downloaded with \code{\link{get_election_data}} needed to compute disproportion}).
#' @param formula variante de cálculo elegido ('gallagher', 'cox_shugart', 'lijphart' o 'rae'). Por defecto es la formula de Gallagher  
#'  
#' @details Una discusión sobre distintas formulas para el cálculo puede encontrarse en 
#' \emph{\href{https://journals.sagepub.com/doi/10.1177/001041407901200101}{"Taagepera and Grofman (2009)"}} 
#' (A discussion of different ways to compute it can be found at
#' \emph{\href{https://journals.sagepub.com/doi/10.1177/001041407901200101}{"Taagepera and Grofman (2009)"}})
#' 
#' @details \strong{REQUISITO:} 
#'
#' @details El formato de \code{data} debe ser \code{long} para calcular \code{\link{compute_disproportion}}. 
#'  Si \code{data} es \emph{wide} se puede transformar con \code{\link{make_long}}  
#'  (\emph{\code{long} format of \code{data} is required for \code{\link{compute_disproportion}}. 
#'  If \code{data} is in \emph{wide} format you can transform it with \code{\link{make_long}}})
#'  
#' @details \strong{NOTA:} 
#' 
#' @details para calcular el grado de desprorpoción el parámetro \code{level} de \code{\link{get_election_data}} debe ser el que descarga por defecto: "provincia"  
#'  (\emph{To compute the degree of disproportion, the parameter \code{level} of \code{\link{get_election_data}} must be "provincia" (\emph{default})}).    
#'  
#' @seealso  \code{\link{compute_competitiveness}, \link{compute_seats}, \link{compute_nep}} 
#' 
#' @return  Devuelve un tibble con \code{class "tbl_df","tbl", "data.frame"} con el cómputo
#'  (\emph{Returns a tibble with \code{class "tbl_df", "tbl", "data.frame"} with the computation}).
#'  
#' @examples
#' 
#' tucuman_dip_gral_2017
#' 
#' tucuman_dip_gral_2017 %>% 
#'   compute_disproportion()
#' 
#' @export



compute_disproportion <- function(data, 
                                  formula = "gallagher"){
  
  
  assertthat::assert_that("listas" %in% colnames(data), 
                          msg = "data is not in a long format. Use 'make_long()' to transform it")
  
  assertthat::assert_that(unique(data$category) %in% c("dip", "sen"), 
                          msg = "compute_disproportion is only possible for legislative elections ('dip', 'sen'). 
                          Explore them with show_available_elections()")
  
  assertthat::assert_that(formula %in% c("gallagher",
                                         "rae",
                                         "cox_shugart",
                                         "lijphart"), msg = "Available formulas are 'gallagher','rae','cox_shugart' and 'lijphart'")
  
  # Compute seats percentage
  seats <- data %>% 
   dplyr::ungroup() %>% 
   polAr::compute_seats() %>%
   dplyr::ungroup() %>% 
   dplyr::mutate(seats_pct = seats/sum(seats)*100) %>% 
   dplyr::select(listas, seats_pct)
 
  
  
  data <- data %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(votes_pct = votos/sum(votos)*100) %>% 
    dplyr::inner_join(seats, by = "listas") %>% 
    dplyr::group_by(category, round, year, codprov, name_prov)
  
   
  # compute indexes 
  
     data <-  if(formula == "gallagher") {
        
        data %>% 
          dplyr::summarise(index = round(sqrt(sum((votes_pct - seats_pct)^2)/2), 2))
    
      } else if(formula == "rae") {
        
        data %>% 
          dplyr::mutate(n = nrow(.)) %>% 
          dplyr::summarise(index = round(sum(abs(votes_pct - seats_pct)/n), 2))
            

      }else if(formula == "cox_shugart"){
        
        data %>% 
          dplyr::summarise(index = round(stats::lm(votes_pct ~ seats_pct)$coefficients[2], 2))
        
      }else if(formula == "lijphart"){
        
        data %>% 
          dplyr::summarise(index = round(max(abs(votes_pct - seats_pct)), 2))
        
        
      }

     
     data %>% 
       dplyr::mutate(formula = formula) %>% 
       dplyr::rename(value = index)
     
     
  }
  




