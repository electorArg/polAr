#' Calcula Numero Efectivo de Partidos Politicos - NEP 
#'  (\emph{Computes Effective Number of Political Parties})
#'  
#' @description
#' Función que calcula el NEP: indicador que provee un número "ajustado" de partidos políticos en un sistema de partídos
#'  (\emph{Function that computes NEP: indicator that provides a "tight" number of political parties in a party system})
#'  
#' @param index un character con la fórmula elegida: "Laakso-Taagepera",  "Golosov" o ambas -opción por defecto- 
#'  (\emph{a character with the chosen formula: 'Laakso-Taagepera', 'Golosov' or both -dafault value}).
#'  
#' @param data la base de datos para hacer el cálculo obtenida con \code{\link{get_election_data}} 
#'  (\emph{tiblle downloaded with \code{\link{get_election_data}} needed to compute nep}).
#'  
#' @details El computo solo se hace a partir de la cantidad de votos de cada lista y no de las bancas 
#'   (\emph{The computation is only made from the number of votes for each ballot and not from the corresponding legislativa seats}).
#'   
#' @details Impementación de las fórmulas \href{https://journals.sagepub.com/doi/10.1177/001041407901200101}{"Laakso-Taagepera"}  y 
#'  \href{https://journals.sagepub.com/doi/10.1177/1354068809339538}{"Golosov"} donde \eqn{p_{1}} es el porcentaje de votos de una lista \eqn{i}
#'  y \eqn{p_{max}} es el porcentaje de votos que sacó la lista más votada 
#'  (\emph{Implementation of the \href{https://journals.sagepub.com/doi/10.1177/001041407901200101}{"Laakso-Taagepera"} and
#'  \href{https://journals.sagepub.com/doi/10.1177/1354068809339538}{"Golosov"} formulas, where \eqn{p_{1}} is vote percentage for a list \eqn{i}
#'  and \eqn{p_{max}} the percentage for the most voted party}). 
#'  
#' @details \eqn{\large Laakso-Tagepera}: \deqn{NEP_{Laakso-Tagepera}=\frac{1}{\sum_{i}^{n}p_{i}^2}}
#' 
#' @details  \eqn{\large Golosov}: \deqn{NEP_{Golosov}=\frac{p_{i}}{\sum_{i}^{n} p_{i}+p_{max}^2-p_{i}^2}}
#' 
#' @details \strong{REQUISITO:} 
#' 
#' @details El formato de \code{data} debe ser \code{long} para calcular \code{\link{compute_nep}}. 
#'  Si \code{data} es \emph{wide} se puede transformar con \code{\link{make_long}}  
#'  (\emph{\code{long} format of \code{data} is required for \code{\link{compute_nep}}. 
#'  If \code{data} is in \emph{wide} format you can transform it with \code{\link{make_long}}})
#'  
#' @details \strong{NOTA:} 
#' 
#' @details el parámetro \code{level} de \code{\link{get_election_data}} determina el nivel de agregacion sobre el que 
#'  se computa el NEP: \code{provincia}, \code{departamento} o \code{circuito}  
#'  (\emph{\code{level} at \code{\link{get_election_data}} determines aggregation on which NEP calculation 
#'  will be made: \code{provincia}, \code{departamento} or \code{circuito}}).    
#'  
#' @seealso  \code{\link{compute_competitiveness}, \link{compute_seats}, \link{compute_disproportion}} 
#' 
#' @return  Devuelve un tibble con \code{class "tbl_df","tbl", "data.frame"} de dimensiones variables seguún el nivel de agrupamiento de 
#'  \code{data} con el cómputo del número ajustado de fuerzas en un sistema de partidos
#'  (\emph{Returns a tibble with \code{class "tbl_df", "tbl", "data.frame"}, of variable dimensions according to the grouping level of
#'   \code{data} with a "tight" numero of political parties in a party system as outcome}).
#'  
#'  Como minimo tres variables (\emph{At least three variables:}): 
#'  
#'  *\code{codprov} que es el agrupamiento de más alto nivel (provincial). Se pueden sumar otros niveles: 
#'    \code{coddepto} para nivel departamental y \code{circuito} para el nivel que le sigue 
#'    (\emph{\code{codprov} which is the highest level grouping -provincial. Other levels can be added:
#'    \code{coddepto} for departmental level and \code{circuito} for the level that follows}).
#'  
#'  * \code{value}: el valor calculado del NEP (\emph{NEP computation})
#'  
#'  * \code{index}: el método utilizado para calcular el NEP (\emph{NEP methodology used for computation})
#' 
#' @examples
#' 
#' tucuman_dip_gral_2017
#' 
#' tucuman_dip_gral_2017 %>% 
#'   compute_nep()
#' 
#' @export



compute_nep <- function(data,
               index = 'All'){
  
  # category check
  assertthat::assert_that(is.character(index),
                          msg = "Please select correct index. Options = c('Golosov', 'Laakso-Taagepera', 'All')")
  
  assertthat::assert_that(index %in% c("Golosov", "Laakso-Taagepera", "All"), 
                          msg = "Please select correct index. Options = c('Golosov', 'Laakso-Taagepera', 'All')")
  
             if(index == "Golosov"){
              
              golosov <- data %>%
               dplyr::mutate(pct = votos/sum(votos)) %>%  # pct votes from total. Depends on agregation level (group_by in election_get())
               dplyr::summarise(value = sum(pct/(pct+max(pct)^2-pct^2))) %>% # NEP FORMULA 
               dplyr::ungroup() %>%
               dplyr::mutate(index = "Golosov")
             
             golosov
             
             
              
            } else if(index == "Laakso-Taagepera"){
              
              laakso <- data %>%
               dplyr::mutate(pct = votos/sum(votos)) %>%  # pct votes from total. Depends on agregation level (group_by in election_get())
               dplyr::summarise(value = 1/sum(pct^2)) %>%  # NEP FORMULA
               dplyr::ungroup() %>%   
               dplyr::mutate(index = "Laakso-Taagepera")
             
             laakso 
              
            } else {
              
              nep1 <-  data %>%
                dplyr::mutate(pct = votos/sum(votos)) %>%  
                dplyr::summarise(value = sum(pct/(pct+max(pct)^2-pct^2))) %>% 
                dplyr::mutate(index = "Golosov")
              
              
              nep2 <- data %>%
                dplyr::mutate(pct = votos/sum(votos)) %>% 
                dplyr::summarise(value = 1/sum(pct^2)) %>%  
                dplyr::mutate(index = "Laakso-Taagepera")
              
              
              all <- dplyr::bind_rows(nep1, nep2)
              
              
              all
    
  }
  
}
