#' Graficar resultados (\emph{Plot results})
#' @description
#' Funcion para graficar resultados de la eleccion (\emph{Function to plot election results})
#' @param data un tibble guardado como objeto en el Enviroment luego de consultar \code{\link{get_election_data}} con parametro \code{level} en \code{provincia} 
#'  (\emph{A tibble saved as an object in the Enviroment after querying \code{\link{get_election_data}}} with \code{provincia} as \code{level} parameter). 
#' @details \strong{REQUISITOS:} 
#' @details \strong{1}. El formato de \code{data} debe ser \code{long} para pdoer graficar. Si \code{data} es \emph{wide} se puede transformar con \code{\link{make_long}} 
#'  (\emph{\code{long} format of \code{data} is required for plotting results. If \code{data} is in \emph{wide} format you can transform it with \code{\link{make_long}}})
#' @details \strong{2.} \code{data} tiene que haber incorporando los nombres de las listas. Agreguelos con \code{\link{get_names}} 
#'  (\emph{\code{data} must have party names. Add them with \code{\link{get_names}}})
#' @details \strong{3.} \code{data} tiene que haber sido descargada con parametro \code{level = provincia} con la funcion \code{\link{get_election_data}} 
#'  (\emph{\code{data} must have \code{level = provincia} wen downloading it with \code{\link{get_election_data}}})
#' 
#' @seealso 
#' \code{\link{tabulate_results}} 
#' 
#' @export

plot_results <- function(data){
  
  
  level <- if(dim(data)[2] == 11){
    c("departamento")
  }else{
    c("provincia")
  }
  
  # Check parameters and data format
  
  assertthat::assert_that(level %in% c("provincia", "departamento"), 
                          msg = glue::glue({level}," is not a valid level. Options are 'provincia' & 'departamento'"))
  
  assertthat::assert_that("listas" %in% colnames(data), 
                          msg = "data is not in a long format. Use 'make_long()' to transform it")
  
  
  assertthat::assert_that("nombre_lista" %in% colnames(data), 
                          msg = "you have to add party labes to 'data' using 'get_names()'")
  
  
  if(level == "departamento"){
    assertthat::assert_that("coddepto" %in% colnames(data), 
                            msg = "data input is not at the correct level 'departamento'. Download it again with parameters:
  get_election_data(..., level = 'departamento)")
    
  } else {
    assertthat::assert_that(dim(data)[2] == 9, 
                            msg = "data is not in the correct 'provincia' level format. Download it again with parameters:
  get_election_data(..., level = 'provincia)")
  }
  
  
  
  # DATA INPUT
  election_district<- unique(data$name_prov) 
  
  election_date <- unique(data$year) 
  
  election_category <- data %>% 
    dplyr::ungroup() %>% 
    dplyr::select(category) %>% 
    dplyr::distinct() %>% 
    dplyr::mutate(value = dplyr::case_when(
      category == "dip" ~ "Diputado Nacional", 
      category == "sen" ~ "Senador Nacional", 
      category == "presi" ~ "Presidente de la Naci\u00F3n"
    )) %>% 
    dplyr::pull()
  
  election_round <- data %>% 
    dplyr::ungroup() %>% 
    dplyr::select(round) %>% 
    dplyr::distinct() %>% 
    dplyr::mutate(value = dplyr::case_when(
      round == "gral" ~ "General", 
      round == "paso" ~ "PASO", 
      round == "balota" ~ "Balotaje"
    )) %>% 
    dplyr::pull()
    
  
 
  ### Plots conditional to level selections
  
  if(level == "provincia"){
    
    datos_prov<- data %>% 
      dplyr::mutate(pct = votos/sum(votos)) %>% 
      dplyr::ungroup()  %>% 
      dplyr::mutate(listas_fct = as.factor(nombre_lista),
                    listas_fct = forcats::fct_reorder(listas_fct, pct))
    
    
    # hack for fill brewer palete 
    
    colourCount = length(unique(datos_prov$listas_fct))
    getPalette = grDevices::colorRampPalette(RColorBrewer::brewer.pal(9, "Set1"))
    
    # plot
    
    
    ggplot2::ggplot(data = datos_prov , 
                    ggplot2::aes(x = listas_fct, y = pct, 
                                 label = listas_fct)) +
      ggplot2::geom_col(show.legend = F, fill = getPalette(colourCount))  +
      ggplot2::geom_text(hjust = "inward") +
      ggplot2::coord_flip() +
      ggplot2::scale_y_continuous(labels = scales::percent) +
      ggplot2::labs(fill = "Listas", 
                    y = "%",
                    title = glue::glue("{election_district} - {election_date}"),
                    subtitle = glue::glue("Elecci\u00F3n {election_round} - {election_category}"), 
                    caption = "Fuente: polAr - Pol\u00EDtica Argentina usando R - https://electorarg.github.io/polAr") +
      ggthemes::theme_fivethirtyeight() + 
    #  hrbrthemes::theme_ipsum()+
      ggplot2::theme(axis.text.y =  ggplot2::element_blank(), 
                     axis.title.y = ggplot2::element_blank(), 
                     panel.spacing.x =ggplot2::unit(0, "cm"), 
                     panel.spacing.y =ggplot2::unit(0, "cm"))
    
    
    
  }else{
    
    
    ##### DEPARTAMENTO
    
    
    # Load geo-grids for 'departamento'
    
    geofacet <-  readRDS(gzcon(url("https://github.com/TuQmano/test_data/blob/master/grillas_geofacet.rds?raw=true")))
    
    
    facet_select <-  geofacet %>%
      purrr::pluck(paste0(election_district))
    
    
    
    datos_depto <- data %>% 
      dplyr::mutate(pct = votos/sum(votos)) %>% 
      dplyr::ungroup()  %>% 
      dplyr::mutate(listas_fct = as.factor(nombre_lista),
                    listas_fct = forcats::fct_reorder(listas_fct, dplyr::desc(pct)))
    
    
    # hack for fill brewer palete 
    colourCount = length(unique(datos_depto$listas_fct))
    getPalette = grDevices::colorRampPalette(RColorBrewer::brewer.pal(9, "Set1"))
    
    
    # plot
    
    
    base_plot_depto <- ggplot2::ggplot(data = datos_depto , 
                    ggplot2::aes("", y = pct, fill = listas_fct)) +
      ggplot2::geom_col(show.legend = T, alpha = 0.85, width = 1) +
      ggplot2::scale_y_continuous(expand = c(0,0), labels = scales::percent, 
                                  breaks =  c(.5, 1)) +
      ggplot2::scale_fill_manual(values = getPalette(colourCount)) +
      ggplot2::labs(fill = "", 
                    y = "% votos",
                    title = glue::glue("{election_district} - {election_date}"),
                    subtitle = glue::glue("Elecci\u00F3n {election_round} - {election_category}"), 
                    caption = "Fuente: polAr - Pol\u00EDtica Argentina usando R - https://electorarg.github.io/polAr") +
      ggthemes::theme_fivethirtyeight() + 
      #hrbrthemes::theme_ipsum(base_size = 11,plot_title_size = 16, subtitle_size = 14,
       #                       strip_text_size = 8, axis_title_size = 14) + 
      ggplot2::theme(axis.text.x = ggplot2::element_blank(), 
                     axis.title.x = ggplot2::element_blank(),
                     axis.ticks.x = ggplot2::element_blank(), 
                     legend.position = "bottom", 
                     aspect.ratio = .7, 
                     legend.key.size = ggplot2::unit(.2, "cm"),
                     legend.key.width = ggplot2::unit(0.2,"cm"), 
                     panel.spacing.x =ggplot2::unit(1.5, "cm"), 
                     panel.spacing.y =ggplot2::unit(0, "cm")) +
      ggplot2::guides(fill = ggplot2::guide_legend(nrow = 7))
    
    
    suppressMessages(base_plot_depto + geofacet::facet_geo(~ coddepto, grid = facet_select, label = "name")) 
    
  }
  
  
  
}