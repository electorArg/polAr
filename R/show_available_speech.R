#' Diccionario de discursos disponibles
#'  (\emph{Speeches collection})
#'  
#' @description
#' Función que devuelve un listado de discursos de apertura de sesiones emitidos por los presidentes de Argentina ante la Asamblea Legislativa.
#'  
#' @param viewer Por defecto es \code{FALSE}. Cuando \code{TRUE} devuelve una tabla en el \emph{Viewer} de \emph{RStudio} 
#'  (\emph{The default is \code{FALSE}. When \code{TRUE} it returns a table in \emph{RStudio Viewer}}).
#'  
#' @return El objeto de salida es un data set con los id dediscursos disponibles para usar como parámetro con
#'  con \code{\link{get_speech}}. Cuando el parámetro es \code{viewer = FALSE}, devuelve un tibble con \code{class "tbl_df","tbl","data.frame"}, y 
#'  cuando es \code{viewer = TRUE} devuelve un objeto con \code{class "datatables","htmlwidget"} 
#'  (\emph{The output is a data set with speeches id needed as parameters in \code{\link{get_speech}}. 
#'  When parameter is set to \code{viewer = FALSE} it returns a tibble and when it is \code{viewer = TRUE} it returns an 
#'  object of \code{class "datatables","htmlwidget"}}).
#'  
#' @examples 
#'  
#'  show_available_speech()
#'  
#'
#' @export


show_available_speech <- function(viewer = FALSE){
  
  
  # Check for internet coection
  attempt::stop_if_not(.x = curl::has_internet(),  # from eph package
                       msg = "No se detecto acceso a internet. Por favor checkea tu conexion.")
  

  
url <- 'https://github.com/electorArg/PolAr_Data/tree/master/speech'  

## FAIL SAFELEY

check <- httr::GET(url)

httr::stop_for_status(x = check, 
                      task = "Fail to download data. Source is not available // La fuente de datos no esta disponible")


# Get list of files from github data repo
pg <- xml2::read_html(url)


filelist <- rvest::html_nodes(pg, "a") %>%
  rvest::html_attr(name = "href" ) %>%
  stringr::str_match('.*csv') %>%
  stats::na.omit() %>% 
  tibble::as_tibble()  %>% 
  dplyr::rename(name = V1) %>% 
  dplyr::mutate(name = stringr::str_remove(name, pattern = "/electorArg/PolAr_Data/blob/master/speech/"),
                name = stringr::str_remove(name, pattern = ".csv")) %>%
  dplyr::transmute(year = stringr::str_sub(name, start = 1, end = 4), 
                   president = stringr::str_sub(string = name, start = 6, end = -1))

if(viewer == TRUE){
  
  x <-  filelist %>%
    dplyr::rename(id = year, 
           Presidente = president) %>% 
    dplyr::mutate(Presidente = stringr::str_replace_all(string = Presidente, pattern = "_", " "), 
                  Presidente = stringr::str_to_title(Presidente)) %>% 
    DT::datatable(options = list( 
      language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json')))
  print(x)
  
  
} else {
  
  filelist
}
}
