#' Diccionario de proyectos de ley sometidos a votación 
#' (\emph{Bills collection})
#'
#'@description
#' Función que devuelve un \emph{data.frame} listado de proyectos de ley con un id por proyecto y cámara legislativa
#' 
#'@param viewer Por default es \code{TRUE} y  muestra una tabla formateada en el \emph{Viewer} de \emph{RStudio}. Cuando \code{FALSE} imprime en consola.
#'
#' @examples 
#'
#' show_available_bills(viewer = FALSE)
#'
#'
#' @seealso  \code{\link{plot_bill}, \link{get_bill_votes}} 
#' 
#' @export




show_available_bills <- function(viewer = FALSE) {
  
  
  url <-  "https://raw.githubusercontent.com/electorArg/PolAr_Data/master/scripts/raw_bills_data.csv"
  
  ## FAIL SAFELEY
  
  check <- httr::GET(url)
  
  httr::stop_for_status(x = check, 
                        task = "Fail to download data. Source is not available // La fuente de datos no esta disponible")
  
  
  
  
  bills <- readr::read_csv(url, 
                  col_types = readr::cols()) %>% 
    dplyr::mutate(id = as.character(glue::glue("{id}-{camara}")),
                  fecha = lubridate::as_date(fecha), 
                  mes = lubridate::month(fecha), 
                  year = lubridate::year(fecha)) %>% 
    dplyr::select(-c(fecha)) 
  
  
  
  if (viewer == TRUE) {
    
    bills %>% 
      DT::datatable(options = list( 
        language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json')))
  
  }else{
      
    bills
    
    }
    
    
}


