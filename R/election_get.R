#'Descarga bases de resultados electorales // Download electoral data 

#'@description
#'Funcion que descarga resultados electorales nacionales desde 2007 //
#'Function that downloads national electoral data since 2007
#'@param district un character con mobre con codigo para argentina y las 24 provincias //
#' a named character with code for Argentina and the 24 provinces
#'@param category un character para la category electoral: diputado -dip-, senador -sen- o presidente -presi //
#' a character with a name for the electoral category: deputy-dip-, senator -sen- or president -presi.
#'@param year un integer para el year de eleccion // an integer for the year of choice
#'@param round un character para tipo de eleccion: primaria -paso- o general -gral- // 
#' a character with a name for the election round: primary -paso- or general -gral
#'@param level un character para seleccionar level de agregación de los resultados: provincia, departamento o circuitos electorales //
#' a character to select the level of aggregation of the results: province -provincia-, department -departamento or electoral precints -circuito. 
#'@param long un boleano para estructura de los datos. Por default ´long´ == FALSE // a boolean for data structure. By default ´long´ == FALSE



#'@export

election_get <- function(district,
                         category,
                         round,
                         year,
                         level = c("provincia", "departamento", "circuito"),
                         long = FALSE){
  
        # Temp function:  level selection
               
  levels <- function(level = ""){
                 
    # Replace if_eses with case_when 
    dplyr::case_when(
      level == "provincia" ~ c("codprov"), 
      level == "departamento" ~ c("codprov, depto, coddepto"),
      level == "circuito" ~ c("codprov, depto, coddepto, circuito"), 
      T ~c("codprov")
    )
              #   if(level == "provincia")
              #     
              #     c("codprov")
              #   
              #   else if(level == "departamento"){
              #     c("codprov, depto, coddepto")
              #     
              #   }else if(level == "circuito"){
              #     c("codprov, depto, coddepto, circuito")
              #     
              #   }else{
              #     c("codprov")
              #   }
                 
               }
               
              levels <- stringr::str_split(string = levels(level = level), pattern = "\\,")
              levels <- stringr::str_squish(levels[[1]])
              levels_long <- c(levels, "listas")
              
  

  if(long == TRUE){
    
   

  readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
                  district, "_",
                  category, "_",
                  round,
                  year, ".csv?raw=true")) %>%
      tidyr::pivot_longer(names_to = "listas",
                          values_to = "votos",
                          cols = c(dplyr::matches("\\d$"), blancos, nulos)) %>%
       dplyr::group_by_at(levels_long) %>% 
      dplyr::summarise_at(.vars = c("votos", "electores"), .funs = sum) %>% 
      dplyr::mutate(category = category,
             round = round, 
             year = year)
  }else{

    readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
                           district, "_",
                           category, "_",
                           round,
                           year, ".csv?raw=true")) %>% 
      dplyr::group_by_at(levels) %>% 
      dplyr::summarise_if(is.numeric, .funs = sum) %>% 
      dplyr::mutate(category = category,
             round = round, 
             year = year) %>% 
      dplyr::group_by_at(levels)

    }
                                }
