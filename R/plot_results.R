#' Grafica resultados (\emph{Plot results})
#' 
#' @description
#' Función para graficar resultados de la elección 
#'  (\emph{Function to plot election results})
#' 
#' @param data un tibble guardado como objeto en el Enviroment luego de consultar \code{\link{get_election_data}} con parámetro
#'  \code{level} en \code{provincia} 
#'  (\emph{tibble saved as an object in the Enviroment after querying \code{\link{get_election_data}}} with \code{provincia} as 
#'  \code{level} parameter). 
#'  
#' @param national un boleano opcional para graficar elecciones presidenciales sin desagregar 
#'  (\emph{an optional boolean to plot presidential elections without disaggregating}). 
#'  
#' @details \strong{REQUISITOS:} 
#' 
#' @details \strong{1}. El formato de \code{data} debe ser \code{long} para poder graficar. Si \code{data} es \emph{wide} se puede 
#'  transformar con \code{\link{make_long}} 
#'  (\emph{\code{long} format of \code{data} is required for plotting results. If \code{data} is in \emph{wide} format you can transform 
#'  it with \code{\link{make_long}}})
#'  
#' @details \strong{2.} \code{data} tiene que haber incorporando los nombres de las listas. Agreguelos con \code{\link{get_names}} 
#'  (\emph{\code{data} must have party names. Add them with \code{\link{get_names}}})
#'  
#' @details \strong{3.} \code{data} tiene que haber sido descargada con parametro \code{level = provincia} con la funcion \code{\link{get_election_data}} 
#'  (\emph{\code{data} must have \code{level = provincia} wen downloading it with \code{\link{get_election_data}}})
#' 
#' @return Devuelve un objeto de \code{class"gg" "ggplot"} que grafica el resultado de una eleccion condicional al nivel de agregacion de data 
#'  (\emph{Returns an object of \code{class "gg" "ggplot"} that plots the election results conditional on the level of \code{data} aggregation.}).
#'  
#' @examples 
#'   
#'  tucuman_dip_gral_2017
#'  
#'  tucuman_dip_gral_2017 %>%
#'        get_names() %>%    
#'        plot_results()
#'
#' @seealso 
#' \code{\link{tabulate_results}} 
#' 
#' @export

plot_results <- function(data, 
                         national = FALSE){
  
  ## Check for internet coection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Internet access was not detected. Please check your connection // 
No se detecto acceso a internet. Por favor chequear la conexion.")
  
  
  
  level <- if(dim(data)[2] == 11) {
     
   c("departamento")
 
   } else if  (dim(data)[1]> 40){ #arbitrary number but large enough to think its provincial level for president election
     
    c("departamento")
     
  } else {
    c("provincia")
  }
  
  # Check parameters and data format
  
  assertthat::assert_that(level %in% c("provincia", "departamento"), 
                          msg = glue::glue({level}," is not a valid level. Options are 'provincia' & 'departamento'"))
  
  assertthat::assert_that("listas" %in% colnames(data), 
                          msg = "data is not in a long format. Use 'make_long()' to transform it")
  
  

  if(level == "departamento"){
    assertthat::assert_that("coddepto" %in% colnames(data) | unique(data$category == "presi"), 
                            msg = "data input is not at the correct level. Download it again with parameters:
  get_election_data(..., level = 'parameter')")
    
  } 
  
  if(national == TRUE){
    assertthat::assert_that(unique(data$category == "presi"), 
                            msg = "The bolean 'national = TRUE' is only for presidential elections.")
  }
  
  # ADD NAMES
  
  data <- if("nombre_lista" %in% names(data)){
    
    data 
    
  }else{
    
    data <- data %>%  get_names()
    
  } 
  

  
  assertthat::assert_that("nombre_lista" %in% colnames(data), 
                          msg = "you have to add party labes to 'data' using 'get_names()'")
  
  
  
  
  # FIX CORRUPT INPUT DATA   
  data <- data %>%
    dplyr::mutate(votos = ifelse(is.na(votos), 0, votos)) # code 0 for NA votes (not reported!)
  
  ### summarize for presidential election
  
  data <-  if(national == TRUE & unique(data$category == "presi")){
    
    
     data %>% 
      dplyr::group_by(category, round, year, listas , nombre_lista) %>% 
      dplyr::summarise_at(.vars = "votos", .funs = sum) %>% 
      dplyr::mutate(codprov = "00",
                    name_prov = "Argentina") %>% 
      dplyr::ungroup()
    
  }else{
    
     data %>% 
      dplyr::select(-electores) # Add here  for fixing bug with presidential elections. 
    # Previous version drop variable afterwards
    
  }
  
  
  # DATA INPUT
  
  election_district <- if(unique(data$category == "presi")){
    "ARGENTINA"
  } else {
      unique(data$name_prov)
    }
  
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
  
  if(level == "provincia" | national == TRUE){
    
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
      ggplot2::theme(axis.text.y =  ggplot2::element_blank(), 
                     axis.title.y = ggplot2::element_blank(), 
                     panel.spacing.x =ggplot2::unit(0, "cm"), 
                     panel.spacing.y =ggplot2::unit(0, "cm"))
    
    
    
  }else{
    
    
    ##### DEPARTAMENTO
    
    # Load geo-grids for 'departamento'
    
 facet_select <-  grillas_geofacet %>%
      purrr::pluck(paste0(election_district))
    
  datos_depto <-  if(election_district == "BUENOS AIRES"){
      
    
    facet_select <-  grillas_geofacet %>%
      purrr::pluck(paste0("PBA"))    
    
    
    data %>%   
        dplyr::left_join(secciones_pba, by = "coddepto") %>% 
        dplyr::ungroup() %>% 
        dplyr::mutate(nombre_lista = forcats::fct_lump(f =nombre_lista,  n = 3, 
                                                     w = votos,
                                                     other_level = "Otros")) %>% 
        dplyr::group_by(seccion, codprov, nombre_lista) %>% 
        dplyr::summarise_if(is.numeric, sum)  %>% 
        dplyr::group_by(codprov, seccion) %>% 
        dplyr::mutate(pct = votos/sum(votos)) %>% 
        dplyr::ungroup()  %>% 
        dplyr::mutate(listas_fct = as.factor(nombre_lista),
                      listas_fct = forcats::fct_reorder(listas_fct, dplyr::desc(pct)))
        
      
      
    }else if(unique(data$category) == "presi"){
    
  data %>%
      dplyr::ungroup() %>% 
      dplyr::mutate(nombre_lista = forcats::fct_lump(f =nombre_lista,  n = 3, 
                                                     w = votos,
                                                     other_level = "Otros")) %>% 
      dplyr::group_by(codprov, nombre_lista) %>%   
      dplyr::summarise(votos = sum(votos)) %>% 
      dplyr::mutate(pct = votos/sum(votos)) %>% 
      dplyr::ungroup()  %>% 
      dplyr::mutate(listas_fct = as.factor(nombre_lista),
                    listas_fct = forcats::fct_reorder(listas_fct, dplyr::desc(pct)))
    
    } else{
      
      
   data %>% 
        dplyr::ungroup() %>% 
        dplyr::mutate(nombre_lista = forcats::fct_lump(f =nombre_lista,  n = 3, 
                                                       w = votos,
                                                       other_level = "Otros")) %>% 
        dplyr::group_by(codprov, coddepto, nombre_lista) %>%   
        dplyr::summarise(votos = sum(votos)) %>% 
        dplyr::mutate(pct = votos/sum(votos)) %>% 
        dplyr::ungroup()  %>% 
        dplyr::mutate(listas_fct = as.factor(nombre_lista),
                      listas_fct = forcats::fct_reorder(listas_fct, dplyr::desc(pct)))
      
      
      
      
    }
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
      ggplot2::theme_minimal() +
      ggplot2::theme(axis.text.x = ggplot2::element_blank(), 
                     axis.title.x = ggplot2::element_blank(),
                     axis.ticks.x = ggplot2::element_blank(), 
                     legend.position = "bottom", 
                     aspect.ratio = .8, 
                     legend.key.size = ggplot2::unit(0.2, "cm"),
                     legend.key.width = ggplot2::unit(0.2,"cm"), 
                     panel.spacing.x =ggplot2::unit(0, "cm"), 
                     panel.spacing.y =ggplot2::unit(0, "cm"), 
                     strip.text = ggplot2::element_text(size = 7)) +
      ggplot2::guides(fill = ggplot2::guide_legend(nrow = 5))
    
   
    if("coddepto" %in% colnames(datos_depto)){
      
      suppressMessages(base_plot_depto + geofacet::facet_geo(~ coddepto, grid = facet_select, label = "name")) 
    
      }else if("seccion" %in% colnames(datos_depto)){
      
      suppressMessages(base_plot_depto + geofacet::facet_geo(~ seccion, grid = facet_select, label = "name"))
      
    } else {
    
      suppressMessages(base_plot_depto + geofacet::facet_geo(~ codprov, grid = facet_select, label = "name")) 
      
    }  # Close departament geofacet
  } # close conditional ploting
  } #close function
  