#'Diccionario de Elecciones disponibles

#'@description
#'Funcion que devuelve un tibble con los parametros necesarios para llamar elecciones con`election_get()`
#'@param viewer Por default es `FALSE`. Cuando `TRUE` devuelve una tabla en el Viewer de RStudio
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
    tidyr::separate(col = name, into = c("distrito", "categoria", "turno"), 
             sep = "\\_", remove = T) %>% 
    dplyr::filter(distrito != "listas") %>% 
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
                                      c("lightgreen","lightpink","lightblue")))%>% 
       DT::formatStyle( 
         'Turno',
         target = 'cell',
         backgroundColor = DT::styleEqual(c("paso","gral"), 
                                          c("lightyellow","lightgrey")))

     print(x)


     } else {
      filelist
  }


}

