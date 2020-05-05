#' Diccionario de Elecciones disponibles 
#'  (\emph{Elections Collection})
#' @description
#' Funcion que devuelve un tibble con los parametros necesarios para llamar elecciones con \code{\link{get_election_data}} 
#'  (\emph{Function that returns a tibble with the necessary parameters to call elections with} \code{\link{get_election_data}})
#' @param viewer Por default es \code{FALSE}. Cuando \code{TRUE} devuelve una tabla en el Viewer de RStudio 
#'  (\emph{The default is \code{FALSE}. When \code{TRUE} it returns a table in RStudio Viewer}).
#' @export

show_available_elections <- function(viewer = FALSE){

  
  # Check for internet coection
  attempt::stop_if_not(.x = curl::has_internet(),  # from eph package
                       msg = "No se detecto acceso a internet. Por favor checkea tu conexion.")
    
  

  # Get list of files from github data repo
  pg <- xml2::read_html(glue::glue('https://github.com/electorArg/PolAr_Data/tree/master/data'))
  
  
  filelist <- rvest::html_nodes(pg, "a") %>%
    rvest::html_attr(name = "href" ) %>%
    stringr::str_match('.*csv') %>%
    stats::na.omit() %>% 
    tibble::as_tibble()  %>% 
    dplyr::rename(name = V1) %>% 
    dplyr::mutate(name = stringr::str_remove(name, pattern = "/electorArg/PolAr_Data/blob/master/data/")) %>% 
    tidyr::separate(col = name, into = c("district", "category", "round"), 
             sep = "\\_", remove = T) %>% 
    dplyr::mutate(year = stringr::str_remove_all(round, "\\D"),
           round = stringr::str_remove_all(round, "\\d")) %>% 
    dplyr::mutate(round = stringr::str_remove_all(round, ".csv"))
  
  
  
  #### province character code and names ######
  
  filelist <- filelist %>% 
    dplyr::mutate(NOMBRE = dplyr::case_when(
      district =="arg" ~    "argentina",    
      district =="caba" ~     "caba",  
      district =="catamarca" ~ "catamarca",  
      district =="chaco" ~    "chaco",  
      district =="chubut" ~   "chubut",  
      district =="cordoba" ~  "cordoba",  
      district =="corrientes" ~ "corrientes", 
      district =="erios" ~    "entre rios",  
      district =="formosa" ~  "formosa",  
      district =="jujuy" ~    "jujuy",    
      district =="mendoza" ~  "mendoza",  
      district =="misiones" ~ "misiones",  
      district =="neuquen" ~  "neuquen",  
      district =="pampa" ~  "la pampa",    
      district =="pba" ~    "buenos aires",    
      district =="rioja" ~  "la rioja",    
      district =="rnegro" ~   "rio negro",  
      district =="salta" ~  "salta",    
      district =="santiago" ~ "santiago del estero",  
      district =="scruz" ~  "santa cruz",    
      district =="sfe" ~    "santa fe",    
      district =="sjuan" ~  "san juan",      
      district =="sluis" ~  "san luis",    
      district =="tdf" ~  "tierra del fuego",      
      district =="tucuman" ~ "tucuman")) %>% 
    dplyr::mutate(NOMBRE = stringr::str_to_upper(NOMBRE))
  
   

  
  
  if(viewer == TRUE){

     x <-  filelist %>%
      DT::datatable(options = list( 
                    language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json')))%>% 
       DT::formatStyle( 
         'category',
         target = 'cell',
         backgroundColor = DT::styleEqual(c("sen","presi", "dip"), 
                                      c("#91bfdb","#ffffbf","#fc8d59")))%>% 
       DT::formatStyle( 
         'round',
         target = 'cell',
         backgroundColor = DT::styleEqual(c("paso","gral"), 
                                          c("#f1a340","#998ec3")))

     print(x)


     } else {
      filelist
  }


}

