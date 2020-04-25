#'Diccionario de Elecciones

#'@description
#'Funcion que devuelve un tibble con los parametros para llamar elecciones con funcion `election_get()`
#'@param viewer Por default es `FALSE`. Cuando `TRUE` devuelve una tabla en el Viewer
#'@export

diccionario_elecciones<- function(viewer = FALSE){

  
  pg <- xml2::read_html(glue::glue('https://github.com/TuQmano/test_data'))
  
  
  filelist <- rvest::html_nodes(pg, "a") %>%
    rvest::html_attr(name = "href" ) %>%
    stringr::str_match('.*csv') %>%
    stats::na.omit() %>% 
    tibble::as_tibble()  %>% 
    dplyr::rename(name = V1) %>% 
    dplyr::mutate(name = stringr::str_remove(name, pattern = "/TuQmano/test_data/blob/master/")) %>% 
    tidyr::separate(name, into = c("distrito", "categoria", "turno"), 
             sep = "[:punct:]", remove = T) %>% 
    dplyr::mutate(anio = stringr::str_remove_all(turno, "\\D"),
           turno = stringr::str_remove_all(turno, "\\d")) %>% 
    janitor::clean_names(case = "big_camel")
  
  
  
  if(viewer == TRUE){

     x <-  filelist %>%
    formattable::formattable()

     print(x)


     } else {
      filelist
  }


}

