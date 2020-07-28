#' Calcula Concentración Elecotral 
#'  (\emph{Computes Electoral Concentration})
#'  
#' @description
#' Calcula el índice de concentración electoral de una elección en función del porecentaje acumulado de las dos listas más votadas
#'  (\emph{Computes the electoral concentration index of an election based on the accumulated percentage of the two most voted lists})
#'  
#' @param data la base de datos para hacer el cálculo obtenida con \code{\link{get_election_data}} 
#'  (\emph{tiblle downloaded with \code{\link{get_election_data}} needed to compute disproportion}).#'  
#' @details \strong{REQUISITO:} 
#'
#' @details El formato de \code{data} debe ser \code{long} para calcular \code{\link{compute_concentration}}. 
#'  Si \code{data} es \emph{wide} se puede transformar con \code{\link{make_long}}  
#'  (\emph{\code{long} format of \code{data} is required for \code{\link{compute_concentration}}. 
#'  If \code{data} is in \emph{wide} format you can transform it with \code{\link{make_long}}})
#'  
#' @details \strong{NOTA:} 
#' 
#' @details el grado de concentración será sensible al nivel de agregación de los datos determinados por el parámetro \code{level} de 
#' \code{\link{get_election_data}}   
#'  (\emph{the degree of concentration will be sensitive to the level of aggregation of the data determined by the parameter \code{level} of
#'   \code{\link{get_election_data}}}).    
#'  
#' @seealso  \code{\link{compute_competitiveness}, \link{compute_seats}, \link{compute_nep}, \link{compute_disproportion} } 
#' 
#' @return  Devuelve un tibble con \code{class "tbl_df","tbl", "data.frame"} con el cómputo de concentración. Puede tomar valores entre \code{0} y \code{1},
#' siendo \code{concentracion = 1} el de mayor grado (un solo partido obtiene todos los votos). 
#'  (\emph{Returns a tibble with \code{class "tbl_df", "tbl", "data.frame"} with concentration computation. It can take values between \code{0}, \code{1}, 
#'  with \code{concentration = 1} being the highest degree (a single party gets all the votes)}).
#'  
#' @examples
#' 
#' tucuman_dip_gral_2017
#' 
#' tucuman_dip_gral_2017 %>% 
#'   compute_concentration()
#' 
#' @export

compute_concentration <- function(data){
  
  
  assertthat::assert_that("listas" %in% colnames(data), 
                          msg = "data is not in a long format. Use 'make_long()' to transform it")

  
  # Temp function:  level selection
  
  levels <- function(level = ""){
    
    # Replace if_elses with case_when 
    dplyr::case_when(
      level == "provincia" ~ c("codprov", "name_prov"), 
      level == "departamento" ~ c("codprov, name_prov, depto, coddepto"),
      level == "circuito" ~ c("codprov, name_prov, depto, coddepto, circuito"), 
      T ~c("codprov")
    )
    
  }
  
  
  level <- if("circuito" %in% names(data)) {
    
    "circuito"
  
  } else if("depto" %in% names(data) & length(data) < 11) {
    
    "departamento"
      
  } else {
      
    "provincia"
    }
  
  levels <- stringr::str_split(string = levels(level = level), pattern = "\\,")
  levels <- stringr::str_squish(levels[[1]])
  
  
  year <- unique(data$year)
  category <- unique(data$category)
  round <- unique(data$round)
  
  data %>%  
    dplyr::mutate(pct = votos/sum(votos)) %>% 
    dplyr::arrange(dplyr::desc(pct)) %>% 
    dplyr::slice(1:2) %>% 
    dplyr::group_by_at( levels) %>% 
    dplyr::summarise(concentration = round(sum(pct),2)) %>% 
    dplyr::mutate(year = year , 
                  category = category, 
                  round = round)
  
  
  }