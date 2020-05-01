
#'Transforma tibble a formato largo (\emph{Transforms a tibble into long format})

#'@description
#'Funcion auxiliar que transforma el tibble WIDE obtenido con \code{\link{get_election_data}} a LONG 
#' (\emph{Auxiliary function that transforms a WIDE tibble obtained with \code{\link{get_election_data}} to LONG format})
#'@param data es el tibble que devuelve \code{\link{get_election_data}} con \code{long = FALSE} como parámetro
#' (\emph{tibble output from \code{\link{get_election_data}} with \code{long = FALSE} as a parameter}).
#'@details El formato de \code{data} debe ser \code{long} tanto para calcular \code{\link{compute_nep}} y \code{\link{compute_competitiveness}}, 
#' como para obtener nombre de listas con \code{\link{get_names}}
#' (\emph{\code{long} format of \code{data} is required for \code{\link{compute_nep}} , \code{\link{compute_competitiveness}} 
#' and \code{\link{get_names}}}).   
#'@export

        get_long <-   function(data){
          
         data %>%
            tidyr::pivot_longer(names_to = "listas",
                                values_to = "votos",
                                cols = c(dplyr::matches("\\d$"), blancos, nulos))
          }
