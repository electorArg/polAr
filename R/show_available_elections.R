#'Diccionario de Elecciones disponibles 
#' (\emph{Elections Collection})

#'@description
#'Funcion que devuelve un tibble con los parametros necesarios para llamar elecciones con \code{\link{get_election_data}} 
#' (\emph{Function that returns a tibble with the necessary parameters to call elections with} \code{\link{get_election_data}})
#'@param viewer Por default es \code{FALSE}. Cuando \code{TRUE} devuelve una tabla en el Viewer de RStudio 
#' (\emph{The default is \code{FALSE}. When \code{TRUE} it returns a table in RStudio Viewer})
#'@export

show_available_elections <- function(viewer = FALSE){

  
  # Check for internet coection
  attempt::stop_if_not(.x = curl::has_internet(),  # from eph package
                       msg = "No se detecto acceso a internet. Por favor checkea tu conexion.")
    
  
  
  # Get list of files from github data repo
  pg <- xml2::read_html(glue::glue('https://github.com/TuQmano/test_data'))
  
  
  filelist <- rvest::html_nodes(pg, "a") %>%
    rvest::html_attr(name = "href" ) %>%
    stringr::str_match('.*csv') %>%
    stats::na.omit() %>% 
    tibble::as_tibble()  %>% 
    dplyr::rename(name = V1) %>% 
    dplyr::mutate(name = stringr::str_remove(name, pattern = "/TuQmano/test_data/blob/master/")) %>% 
    tidyr::separate(col = name, into = c("distrito", "categoria", "turno"), 
             sep = "\\_", remove = T) %>% 
    dplyr::filter(distrito != "listas") %>%  # remove lists files from collection
    dplyr::mutate(anio = stringr::str_remove_all(turno, "\\D"),
           turno = stringr::str_remove_all(turno, "\\d")) %>% 
    dplyr::mutate(turno = stringr::str_remove_all(turno, ".csv")) %>% 
    janitor::clean_names(case = "big_camel")
  
  
  
  if(viewer == TRUE){

     x <-  filelist %>%
      DT::datatable(options = list( 
                    language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json')))%>% 
       DT::formatStyle( 
         'Categoria',
         target = 'cell',
         backgroundColor = DT::styleEqual(c("sen","presi", "dip"), 
                                      c("#91bfdb","#ffffbf","#fc8d59")))%>% 
       DT::formatStyle( 
         'Turno',
         target = 'cell',
         backgroundColor = DT::styleEqual(c("paso","gral"), 
                                          c("#f1a340","#998ec3")))

     print(x)


     } else {
      filelist
  }


}

