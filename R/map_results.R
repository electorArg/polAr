#' Mapea resultados (\emph{Map results})
#' 
#' @description
#' Función para mapear resultados de la elección 
#'  (\emph{Function to map election results})
#' 
#' @param data un tibble guardado como objeto en el Enviroment luego de consultar \code{\link{get_election_data}} con parámetro
#'  \code{level} en \code{provincia} para elecciones presidenciales y \code{level} en \code{departamento} para legislativas 
#'  (\emph{tibble saved as an object in the Enviroment after querying \code{\link{get_election_data}}} with \code{provincia} as 
#'  \code{level} parameter for presidential elections and \code{departmanto} for legislative elections). 
#'  #'  
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
#' @return Devuelve un objeto de \code{class"gg" "ggplot"} que mapea el resultado de una eleccion condicional al nivel de agregacion de data 
#'  (\emph{Returns an object of \code{class "gg" "ggplot"} that plots the election results in a map conditional on the level of \code{data} aggregation.}).
#'  
#'
#' @seealso 
#' \code{\link{tabulate_results}, \link{plot_results}} 
#' 
#' @export



map_results <- function(data){

  
  level <- if("circuito" %in% colnames(data)) {
    
    c("circuito")
    
  } else if  (dim(data)[2] == 8){ 
    c("provincia")
    
  } else {
    c("departamento")
  }
  
  
  
  
  ## Check for internet coection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Internet access was not detected. Please check your connection // 
No se detecto acceso a internet. Por favor chequear la conexion.")
  
  # Check parameters and data format
  
  assertthat::assert_that("listas" %in% colnames(data), 
                          msg = "data is not in a long format. Use 'make_long()' to transform it")
  
  assertthat::assert_that(level %in% c("provincia", "departamento"), 
                          msg = glue::glue({level}," is not a valid level. Options are 'provincia' for presidential elections & 'departamento' for legislative elections"))
  
  if(unique(data$category) %in% c("dip", "sen")){
    
  assertthat::assert_that(level == "departamento" & "coddepto" %in% colnames(data), 
                          msg = glue::glue({level}," is not a valid level for legislative election. Download it at 'departamento' level"))

  }else if(unique(data$category) == "presi" & level == "departamento"){
     
    assertthat::assert_that(level == "provincia", 
                            msg = glue::glue({level}," is not a valid level for presidential election. Download it at 'provincia' level"))
    
    
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
  

  
      ## COMPUTE VOTES
      votes_pct <- if(unique(data$category) == "presi"){
        
         #PRESIDENTIAL DATA
        
      data %>%
        dplyr::group_by(codprov) %>% 
        dplyr::filter(!listas %in% c("blancos", "nulos")) %>% 
        dplyr::mutate(pct = votos/sum(votos)*100)  %>% 
        polAr::get_names() 
      
        }else{
        
        # LEGISLTIVE DATA
        
      data %>%
        dplyr::group_by(codprov, coddepto) %>% 
        dplyr::filter(!listas %in% c("blancos", "nulos")) %>% 
        dplyr::mutate(pct = votos/sum(votos)*100)  %>% 
        polAr::get_names()
        
      }
      
  ### GET FRONT RUNNERS
  front_runners <- votes_pct %>% 
    dplyr::ungroup() %>% 
    dplyr::group_by(nombre_lista) %>% 
    dplyr::summarise(totales = sum(votos)) %>% 
    dplyr::top_n(n = 2, wt = totales) %>% 
    dplyr::arrange(dplyr::desc(totales))


  data <- votes_pct %>%
    dplyr::filter(nombre_lista %in% front_runners$nombre_lista) %>%
    dplyr::left_join(front_runners, by = "nombre_lista") %>% 
    dplyr::arrange(dplyr::desc(totales)) %>% 
    dplyr::mutate(dif = pct - dplyr::lead(pct), 
           winer = ifelse(dif > 0, nombre_lista, dplyr::lead(nombre_lista))) %>% 
    dplyr::slice(1) %>% 
    dplyr::mutate(group = dplyr::case_when(
      dif > 0 & dif < 5 ~ 5, 
      dif >= 5 & dif < 10 ~ 10, 
      dif >= 10 & dif < 15 ~ 15,
      dif >= 15 ~ 20, 
      dif < 0 & dif > -5 ~ -5, 
      dif <= -5 & dif > -10 ~ -10, 
      dif <= -10 & dif > -15 ~ -15,
      dif <= -15 ~ -20, 
    ))


# IMPORT MAPS CONDITIONAL

      if(unique(data$category) == "presi"){ 
    
      # ARG MAP
    map <-   sf::read_sf("https://github.com/electorArg/PolAr_Data/raw/master/geo/provincias.geojson") 
    
     

      
  # PRESIDENTIAL ELECTION
        # NATIONAL MAP
        pais <- data %>% 
          dplyr::left_join(map, by = "codprov") %>% 
          sf::st_as_sf() %>% 
        ggplot2::ggplot() +
          ggplot2::geom_sf(ggplot2::aes(fill = group))  +
          ggplot2::geom_rect(xmin = -59, xmax = -58, ymin = -34, ymax = -35, 
                    fill = NA, colour = "black", size = 1.5) +
          ggthemes::theme_map() +
          ggplot2::scale_fill_gradient2(low = "#7fbf7b", mid = "white", high = "#af8dc3", 
                                        limits = c(-20, 20), 
                                        breaks = c(-20, -15, -10, -5, 0, 5, 10, 15, 20), 
                                        labels = c(paste0("20 o + \n", front_runners$nombre_lista[2]),
                                                   "15", 
                                                   "10",
                                                   "5",
                                                   "0",
                                                   "5", 
                                                   "10",
                                                   "15",  
                                                   paste0(front_runners$nombre_lista[1], "\n20 o +")))  +
          ggplot2::theme(legend.direction = "vertical", 
                         legend.position = "right", 
                         legend.text.align = 0, 
                         legend.spacing.x = ggplot2::unit(.5, 'cm'),
                         legend.text = ggplot2::element_text(margin = ggplot2::margin(t = 10)))  +
          ggplot2::labs(fill = "",
                        title = glue::glue("Elecci\u00F3n a {election_category} - {election_round} {election_date}"),
                        subtitle = "Puntos Porcentuales de Diferencia", 
                        caption = "Fuente: polAr - Pol\u00EDtica Argentina usando R - https://electorarg.github.io/polAr")
  

        # SUBSET MAP
        caba <- data %>%
          dplyr::left_join(map, by = "codprov")  %>% 
          sf::st_as_sf() %>%
         ggplot2::ggplot() +
          ggplot2::geom_sf(ggplot2::aes(fill =  group)) + 
          ggplot2::coord_sf(xlim = c(-58.55, -58.3), 
                   ylim = c(-34.75, -34.5), expand = FALSE) +
          ggplot2::geom_rect(xmin = -58.55, xmax = -58.3, ymin = -34.5, ymax = -34.75, 
                    fill = NA, colour = "black", size = 1.5) +
          ggthemes::theme_map() +
          ggplot2::scale_fill_gradient2(low = "#7fbf7b", mid = "white", high = "#af8dc3")  +
          ggplot2::theme(legend.position = "none") 


        # COWPLOT COMBINE
            
            cowplot::ggdraw(pais) +
              cowplot::draw_plot(caba, 
                        width = 0.26, 
                        height = 0.26 * .5, 
                        x = 0.6, y = 0.5) 
            
            
      }else{ 
        
        # PROVs MAPs
    map <-  sf::read_sf("https://github.com/electorArg/PolAr_Data/raw/master/geo/departamentos.geojson") %>% 
      dplyr::rename(coddepto = coddept) %>% 
      dplyr::select(-depto)
       
    
     if (unique(data$name_prov) == "BUENOS AIRES"){
       
       pba <- data %>% 
         dplyr::left_join(map, by = c("codprov", "coddepto")) %>% 
         sf::st_as_sf() %>% 
         ggplot2::ggplot() +
         ggplot2::geom_sf(ggplot2::aes(fill = group))  +
         ggplot2::geom_rect(xmin = -59, xmax = -58, ymin = -34, ymax = -35, 
                            fill = NA, colour = "black", size = 1.5) +
         ggthemes::theme_map() +
         ggplot2::scale_fill_gradient2(low = "#7fbf7b", mid = "white", high = "#af8dc3", 
                                       breaks = c(-20, -15, -10, -5, 0, 5, 10, 15, 20), 
                                       limits = c(-20, 20), 
                                       labels = c(paste0("20 o + \n", front_runners$nombre_lista[2]),
                                                  "15", 
                                                  "10",
                                                  "5",
                                                  "0",
                                                  "5", 
                                                  "10",
                                                  "15",  
                                                  paste0(front_runners$nombre_lista[1], "\n20 o +")))  +
         ggplot2::theme(legend.direction = "vertical", 
                        legend.position = "right", 
                        legend.text.align = 0, 
                        legend.spacing.x = ggplot2::unit(.5, 'cm'),
                        legend.text = ggplot2::element_text(margin = ggplot2::margin(t = 10)))  +
         ggplot2::labs(fill = "",
                       title = glue::glue("Elecci\u00F3n a {election_category} por {election_district} - {election_round} {election_date}"),
                       subtitle = "Puntos Porcentuales de Diferencia", 
                       caption = "Fuente: polAr - Pol\u00EDtica Argentina usando R - https://electorarg.github.io/polAr")
       
       
       # SUBSET MAP
       amba <- data %>%
         dplyr::left_join(map, by = c("codprov", "coddepto"))  %>% 
         sf::st_as_sf() %>%
         ggplot2::ggplot() +
         ggplot2::geom_sf(ggplot2::aes(fill =  group)) + 
         ggplot2::scale_fill_gradient2(low = "#7fbf7b", mid = "white", high = "#af8dc3")  +
         ggplot2::coord_sf(xlim = c(-59, -58), 
                           ylim = c(-35, -34), expand = FALSE) +
         ggplot2::geom_rect(xmin = -59, xmax = -58, ymin = -34, ymax = -35, 
                            fill = NA, colour = "black", size = 1.5) +
         ggthemes::theme_map() +
         ggplot2::theme(legend.position = "none") 
       
       
       # COWPLOT COMBINE
       
       cowplot::ggdraw(pba) +
         cowplot::draw_plot(amba, 
                            width = 0.3, 
                            height = 0.3 , 
                            x = 0.7, y = 0.6) 
       
       
       
       
       
       
       
     } else {
    
    
    
    data %>% 
      dplyr::left_join(map, by = c("codprov", "coddepto")) %>% 
      sf::st_as_sf() %>%
      ggplot2::ggplot() +
      ggplot2::geom_sf(ggplot2::aes(fill =  group)) + 
        ggthemes::theme_map() +
      ggplot2::scale_fill_gradient2(low = "#7fbf7b", mid = "white", high = "#af8dc3", 
                                    limits = c(-20, 20),
                                    breaks = c(-20, -15, -10, -5, 0, 5, 10, 15, 20),  
                                    labels = c(paste0("20 o + \n", front_runners$nombre_lista[2]),
                                               "15", 
                                               "10",
                                               "5",
                                               "0",
                                               "5", 
                                               "10",
                                               "15",  
                                               paste0(front_runners$nombre_lista[1], "\n20 o +")))  +
      ggplot2::theme(legend.direction = "vertical", 
                     legend.position = "right", 
                     legend.text.align = 0, 
                     legend.spacing.x = ggplot2::unit(.5, 'cm'),
                     legend.text = ggplot2::element_text(margin = ggplot2::margin(t = 10))) +
      ggplot2::labs(fill = "",
                    title = glue::glue("Elecci\u00F3n a {election_category} por {election_district} - {election_round} {election_date}"),
                    subtitle = "Puntos Porcentuales de Diferencia", 
                    caption = "Fuente: polAr - Pol\u00EDtica Argentina usando R - https://electorarg.github.io/polAr")
    

      } # Close  provs != PBA if condition

    } # Close legislative if condition
  
} # Close function


