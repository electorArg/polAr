#' Transforma tibble a formato largo (\emph{Transforms a tibble into long format})
#' @description
#' 
#' Función auxiliar que transforma el tibble \emph{wide} obtenido con \code{\link{get_election_data}} a \emph{long}  
#'  (\emph{Auxiliary function that transforms a \emph{wide} tibble obtained with \code{\link{get_election_data}} to \emph{long} format}).
#'  
#' @param data es el tibble que devuelve \code{\link{get_election_data}} con \code{long = FALSE} como parámetro
#'  (\emph{tibble output from \code{\link{get_election_data}} with \code{long = FALSE} as a parameter}).
#'  
#' @details El formato de \code{data} debe ser \code{long} tanto para calcular \code{\link{compute_nep}} y \code{\link{compute_competitiveness}}, 
#'  como para obtener nombre de listas con \code{\link{get_names}}
#'  (\emph{\code{long} format of \code{data} is required for \code{\link{compute_nep}} , \code{\link{compute_competitiveness}} 
#'  and \code{\link{get_names}}}).   
#'  
#' @return transforma \code{data} a formato alargado utilizando \code{\link[tidyr]{pivot_longer}} sin cambiar \code{class 
#'  "tbl_df","tbl","data.frame"} de origen  pero aumentando el número de filas y reduciendo el de columnas   
#'  (\emph{It makes data longer with \code{\link[tidyr]{pivot_longer}}. It returns  \code{data} of \code{class 
#'  "tbl_df","tbl","data.frame"} as the original but increasing the number of rows and decreasing the number of columns}).  
#'  
#' @export

        make_long <-   function(data){
          
         data %>%
            tidyr::pivot_longer(names_to = "listas",
                                values_to = "votos",
                                cols = c(dplyr::matches("\\d$"), blancos, nulos))
          }
