#' Calcula número de bancas de diputados a repartir en una elección  
#'  (\emph{Computes allocation of legislative seats})
#'  
#' @description
#' Función que calcula la distribución proporcional de escaños para la categoría Diputado Nacional y 
#' de mayoría/minoría para Senaor Nacional en función de votos obtenidos
#'  (\emph{Function that computes propotional allocation of Diputados and Senadores seats})
#'  
#' @param data un data.frame con los resultados de una elección para agregados a nivel provincial 
#'  (\emph{a data.frame with aggregate electoral results at provincial level}).
#'
#' @details 
#' 1. La distribución de escaños esta regida por la formula del sistema \emph{D'Hondt} para Diputados y mayoría/minoría para Senadores.
#' 2. La cantidad de escaños de cada provincia dependen de su población con un mínimo de \eqn{5} por provincia. 
#' En caso de Senadores se asignan \eqn{2} al de mayor votos y \eqn{1} al segundo. 
#' 3. En el caso de Diputados, La renovación de bancas de cada provincia se realiza por mitades cada dos años. Cuando la cantidad de 
#' escaños que corresponden a una provincia es impar las mismas eligen un diputado más en uno de los turnos: o concurrentes
#' con elecciones presidenciales, o en elecciones de mitad de termino presidencial.
#' En el caso de Senadores su mandato es de 6 años y se renuevan parcialmente por grupos de 8 provincias. 
#'
#'
#' @examples 
#' 
#'  polAr::get_election_data(district = "caba", 
#'                           category = "dip",
#'                           round = "gral", 
#'                           year = 2007) -> caba_dip_2007
#'  
#'  caba_dip_2007                         
#'  
#'                           
#'  compute_seats(data = caba_dip_2007)                         
#'
#' @seealso  \code{\link{compute_nep}, \link{compute_competitiveness}} 
#'
#' @export  


compute_seats <- function(data){
  
  ### ORIGINAL SOURCE CODE https://github.com/cran/electoral/blob/master/R/seats_highest_averages.R
  
  
  ## Check for internet coection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Internet access was not detected. Please check your connection // 
No se detecto acceso a internet. Por favor chequear la conexion.")
  
  # Check parameters and data format
  
  assertthat::assert_that(dim(data)[2]== 8,  
                          msg = "data is not at valid level. Download it at 'provincia' level")
  
  assertthat::assert_that("listas" %in% colnames(data), 
                          msg = "data is not in a long format. Use 'make_long()' to transform it")
  
  
  
  
  ## SET polAr DATA PARAMETERS
  presi_years <- seq(from = 1983, to = 2043, by = 4)
  midterm_years <- seq(from = 1985, to = 2045, by = 4)
  seats_election <- readr::read_csv("https://raw.githubusercontent.com/electorArg/PolAr_Data/master/geo/seats_province_election_type.csv", 
                                    col_types = readr::cols())
  
  
  ### WRAGNLE DATA 
  
    ## CHECK FOR PARTY LIST NAMES IN DATA 
  
  
 data <-  if("nombre_lista" %in% names(data)){
    
    data
  } else {
    
    data %>% 
      polAr::get_names()
    
  }
  
  
  
  data <- data %>% 
    dplyr::mutate(type = dplyr::case_when(
      year %in% presi_years ~ "presidentials",
      year %in% midterm_years ~ "midterms"
    )) %>% 
    dplyr::left_join(seats_election, by = c("codprov", "type")) %>% 
    dplyr::filter(!stringr::str_detect(listas, "\\D"))%>% 
    dplyr::group_by(codprov, name_prov)
  
  
  
  
  seats <- if("dip" %in% data$category){ #DIPTUADOS SEATS
  
  
  ### COMPUTE DHONDT SEATS DISTRIBUTION 
  seats <- 1:unique(data$seats)
  
  votes <- data  %>% 
    dplyr::transmute(PARTY = nombre_lista,
                     VOTES = votos,
                     year, category, round) 
  
  quot <- tibble::as_tibble(expand.grid(PARTY = data$nombre_lista,
                                DIVISOR = seats)) %>%
    dplyr::mutate(PARTY = as.character(PARTY)) %>%
    dplyr::left_join(votes, by = 'PARTY') %>%
    dplyr::mutate(QUOTIENTS = VOTES/DIVISOR) %>%
    dplyr::mutate(ORDER=rank(-QUOTIENTS, ties.method='max'))
  
  seats <- quot %>%
    dplyr::arrange(ORDER) %>%
    dplyr::filter(ORDER <= length(seats)) %>%
    dplyr::group_by(year, category, round, codprov, name_prov, nombre_lista = PARTY) %>%
    dplyr::summarise(seats=dplyr::n())%>% 
    dplyr::select(codprov, name_prov, year, category, round, nombre_lista, seats) %>% 
    dplyr::arrange(dplyr::desc(seats))
  
  
  seats
  
  }else{  # SENADORES SEATS
    
    
    data %>% 
      dplyr::arrange(dplyr::desc(votos)) %>% 
      dplyr::slice(1:2) %>% 
      dplyr::mutate(seats = c(2, 1))
    
    
    
  }

  seats %>% 
    dplyr::select(codprov, 
                  name_prov, 
                  year, 
                  category, 
                  round,
                  nombre_lista, 
                  seats)
  
}
