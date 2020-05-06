#' Tabular resultados (\emph{Tabulate results})
#' @description
#' Funcion para tabular resultados de la eleccion  
#'  (\emph{Function to tabulate election results})
#' @param data un tibble guardado como objeto en el Enviroment luego de consultar \code{\link{get_election_data}} con parametro \code{level} en \code{provincia} 
#'  (\emph{A tibble saved as an object in the Enviroment after querying \code{\link{get_election_data}} with \code{provincia} as \code{level} parameter}).
#' @param LaTeX parametro para obtener codigo \code{LaTeX} de la tabla de salida. 
#'  Ejemplo de uso en \href{https://www.overleaf.com/read/vyfgpyrrjmkg}{Overleaf} 
#'  (\emph{parameter to get \code{LaTeX} code in the ouptut table. \href{https://www.overleaf.com/read/vyfgpyrrjmkg}{Overleaf} example usage}).
#' @return Tabulado con resultados agregados de la eleccion 
#'  (\emph{Table with aggregated election results}).
#' @details \strong{REQUISITOS:} 
#' @details \strong{1}. El formato de \code{data} debe ser \code{long} para calcular resultados. 
#'  Si \code{data} es \emph{wide} se puede transformar con \code{\link{make_long}} 
#'  (\emph{\code{long} format of \code{data} is required for getting results. 
#'  If \code{data} is in \emph{wide} format you can transform it with \code{\link{make_long}}})
#' @details \strong{2.} \code{data} tiene que haber incorporando los nombres de las listas. Agreguelos con \code{\link{get_names}}
#'  (\emph{\code{data} must have party names. Add them with \code{\link{get_names}}})
#' @details \strong{3.} \code{data} tiene que haber sido descargada con parametro \code{level = provincia} con la funcion \code{\link{get_election_data}}
#'  (\emph{\code{data} must have \code{level = provincia}  wen downloading it with \code{\link{get_election_data}}})
#' 
#' @seealso 
#' \code{\link{plot_results}}
#'  
#' @export
 

 tabulate_results <- function(data, 
                         LaTeX = F) {
   
    
    # check long foramt
    assertthat::assert_that("listas" %in% colnames(data), 
                            msg = "data is not in a long format. Use 'make_long()' to transform it")
    
    assertthat::assert_that("nombre_lista" %in% colnames(data), 
                            msg = "data has no party_labels Use 'get_names()' to add them")
    
    assertthat::assert_that(dim(data)[2] == 9, 
                            msg = "data is not in the correct 'provincia' level format")
    
    
    
    ### summarize for presidential election
    
    if(unique(data$category) == "presi"){
        
        
       data <-  data %>% 
            dplyr::group_by(category, round, year, listas , nombre_lista) %>% 
            dplyr::summarise_at(.vars = "votos", .funs = sum) %>% 
            dplyr::mutate(codprov = "00",
                          name_prov = "Argentina") %>% 
            dplyr::ungroup()
        
    } else {
        
        data %>% 
         dplyr::select(-electores) # Add here  for fixing bug with presidential elections. 
                                   # Previous version drop variable afterwards

    }

    
    # Compute pct votes and arrange
    
    temp <-  data %>%
       dplyr::mutate(votos = votos/sum(votos)) %>% 
       dplyr::arrange(dplyr::desc(votos))
    
    
    
    # TABLE TEXT DATA INPUT
    election_district<- unique(temp$name_prov) 
    
    election_date <- unique(temp$year) 
    
    election_category <- temp %>% 
       dplyr::ungroup() %>% 
       dplyr::select(category) %>% 
       dplyr::distinct() %>% 
       dplyr::mutate(value = dplyr::case_when(
          category == "dip" ~ "Diputado Nacional", 
          category == "sen" ~ "Senador Nacional", 
          category == "presi" ~ "Presidente de la Naci\u00F3n"
       )) %>% 
       dplyr::pull()
    
    election_round <- temp %>% 
       dplyr::ungroup() %>% 
       dplyr::select(round) %>% 
       dplyr::distinct() %>% 
       dplyr::mutate(value = dplyr::case_when(
          round == "gral" ~ "General", 
          round == "paso" ~ "PASO", 
          round == "balota" ~ "Balotaje"
       )) %>% 
       dplyr::pull()
    
    
    if(LaTeX == F){    
       
    # GT TABLE 
    temp %>%
       dplyr::ungroup() %>% 
       dplyr::mutate(lista = dplyr::case_when(
          nombre_lista %in% c("blancos", "nulos") ~ nombre_lista, 
          T ~ paste0(listas, "-", nombre_lista))) %>% 
       dplyr::rename("Lista" = lista, "Votos" = votos) %>% 
       dplyr::select(-c(category, round, year, codprov, name_prov, listas, nombre_lista)) %>% 
       gt::gt() %>% 
       gt::cols_move_to_start(c("Lista", "Votos")) %>% 
       gt::fmt_percent("Votos",decimals = 1) %>%
       gt::tab_header(
          title = glue::glue("{election_district} - {election_date}"),
          subtitle = glue::glue("Elecci\u00F3n {election_round} - {election_category}")) %>% 
       gt::tab_source_note(
          source_note = gt::md("**Fuente:** polAr - Pol\u00EDtica Argentina usando R - *https://electorarg.github.io/polAr*"))
    
    } else {
       
       temp %>%
          dplyr::ungroup() %>% 
          dplyr::mutate(lista = dplyr::case_when(
             nombre_lista %in% c("blancos", "nulos") ~ nombre_lista, 
             T ~ paste0(listas, "-", nombre_lista))) %>% 
          dplyr::rename("Lista" = lista, "Votos" = votos) %>% 
          dplyr::select(-c(category, round, year, codprov, name_prov, listas, nombre_lista)) %>% 
          gt::gt() %>% 
          gt::cols_move_to_start(c("Lista", "Votos")) %>% 
          gt::fmt_percent("Votos",decimals = 1) %>%
          gt::tab_header(
             title = glue::glue("{election_district} - {election_date}"),
             subtitle = glue::glue("Elecci\u00F3n {election_round} - {election_category}")) %>% 
          gt::tab_source_note(
             source_note = gt::md("**Fuente:** polAr - Pol\u00EDtica Argentina usando R - *https://electorarg.github.io/polAr*")) %>% 
          gt::as_latex() -> latex
       
     
       latex %>%
          as.character() %>%
          cat()
         
    }
    
    
 }
 