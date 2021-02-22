#' Obtener votos de un proyecto de ley 
#' (\emph{Download bill vote data})
#'
#'@description
#' Función que devuelve un \emph{data.frame} con el detalle de los votos individuales de los legisladores a un proyecto de ley. 
#' 
#'@param bill Parametro en el que se especifica el id del proyecto obtenido con \code{\link{show_available_bills}}
#'
#' @examples 
#'
#' get_bill_votes(bill = "1926-Diputados")
#' 
#' @seealso  \code{\link{plot_bill}, \link{show_available_bills}}
#'
#' @export


get_bill_votes <- function(bill =NULL){
  
  ## Check for internet conection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Internet access was not detected. Please check your connection // 
No se detecto acceso a internet. Por favor chequear la conexion.")
  
  # FAIL SAFELY
  
  url <- "https://raw.githubusercontent.com/electorArg/PolAr_Data/master/scripts/raw_bills_data.csv"
  check <- httr::GET(url)
  
  httr::stop_for_status(x = check, 
                        task = "Fail to download election data. Source is not available // La fuente de datos electorales no esta disponible")
  
  
  
  
  data <- readr::read_csv(url, 
                          col_types = readr::cols()) %>% 
    dplyr::mutate(id = as.character(glue::glue("{id}-{camara}")),
                  fecha = lubridate::as_date(fecha), 
                  mes = lubridate::month(fecha), 
                  year = lubridate::year(fecha)) %>% 
    dplyr::select(-c(camara, fecha)) 
  
  
  selection <- if(bill %in% data$id){
    
    data %>% 
      dplyr::filter(id == bill) %>% 
      dplyr::mutate(chamber = dplyr::case_when(
        stringr::str_detect(id, "Dipu") ~ "dip", 
        TRUE ~ "sen"), 
        id = stringr::str_remove_all(id, "\\D"))
    
  } else {
    
    "Error: bill was not found // votacion no disponible"
  }
  
  jsonlite::read_json(glue::glue("https://raw.githubusercontent.com/electorArg/PolAr_Data/master/legis/{selection$chamber}/votos/{selection$year}/{selection$id}.json")) %>% 
    tibble::enframe() %>% 
    tidyr::unnest_wider(col = value)
  
  
  
}

