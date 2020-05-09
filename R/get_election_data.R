#' Descarga bases de resultados electorales 
#'  (\emph{Download electoral data})
#'  
#' @description
#' Función que descarga resultados electorales nacionales desde 2007 
#'  (\emph{Function that downloads national electoral data since 2007})
#'  
#' @param district un character con código para Argentina y las 24 provincias
#'  (\emph{a named character with code for Argentina and the 24 provinces}).
#'  
#' @param category un character para la categoría electoral: diputado \code{dip}, senador  \code{sen} o  presidente \code{presi}
#'  (\emph{a character with a name for the electoral category: deputy \code{dip}, senator \code{sen} or president \code{presi}}).
#'  
#' @param year un integer para el año de eleccion (\emph{an integer for the year of choice}).
#' 
#' @param round un character para tipo de elección: primaria \code{paso} o general  \code{gral} 
#'  (\emph{a character with a name for the election round: primary \code{paso} or general \code{gral}}).
#'  
#' @param level un character para seleccionar level de agregación de los resultados: \code{provincia}, \code{departamento} o \code{circuito}
#'  (\emph{a character to select the level of aggregation of the results: province \code{provincia}, department -\code{departamento} or 
#'  electoral precints \code{circuito}}). 
#'  
#' @param long un boleano para estructura de los datos. Por default \code{long = FALSE} 
#'  (\emph{a boolean for data structure. By default} \code{long = FALSE}).
#'  
#' @param raw un boleano \code{TRUE/FALSE} que define si descargar base de datos desagregada a nivel MESA o no 
#'  (\emph{a \code{TRUE/FALSE} boolean to define whether to download disaggregated data at BALLOT level or not})
#'  
#' @return devuelve un tibble con \code{class "grouped_df", "tbl_df","tbl", "data.frame"} con los resultados de una eleccion determinada 
#'  (\emph{returns a tibble with electoral results of interest with \code{class "grouped_df", "tbl_df","tbl", "data.frame"}}).
#' 
#' @examples 
#'  get_election_data(district = "caba",   
#'                    category = "dip", 
#'                    round = "paso", 
#'                    year = 2011,  
#'                    level = "provincia", 
#'                    long = TRUE, raw = FALSE)                    
#'  
#'  
#'@export

get_election_data <- function(district = NULL ,
                              category = NULL,
                              round = NULL ,
                              year = NULL,
                              level = "provincia",
                              long = TRUE, 
                              raw = FALSE){
  
  
  
  ## Check for internet coection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Internet access was not detected. Please check your connection // 
No se detecto acceso a internet. Por favor chequear la conexipn.")
  
  ## Check params 

  # year check
  
  assertthat::assert_that(!is.null(year), 
                          msg = "You must provide valid character parameters for 'district', 'category' and 'round', and an integer parameter for 'year'. Check them with show 'show_available_elections()' //
Debe proporcionar parametros character validos para 'district', 'category' y 'round', y un parametro entero para 'year'. Compruebelos con 'show show_available_elections()'")
  
  assertthat::assert_that(is.numeric(year), 
                          msg = "'year' must be an integer. Please select a correct option.  Check them with 'show_available_elections()' //
'year' debe ser un integer. Por favor seleccione una opcipn correcta. Verifiquelos con 'show_available_elections()'")
  
  # category check
  
  assertthat::assert_that(!is.null(category), 
                          msg = "You must provide valid character parameters for 'district', 'category' and 'round', and an integer parameter for 'year'. Check them with show 'show_available_elections()' //
 Debe proporcionar parametros character validos para 'district', 'category' y 'round', y un parametro entero para 'year'. Compruebelos con 'show show_available_elections()'")
  
  assertthat::assert_that(is.character(category),
                          msg = "'category' must be an character string Please select a correct option.  Check them with 'show_available_elections()' //
'category' debe ser un character string Por favor seleccione una opcipn correcta. Verifiquelas con 'show_available_elections()'")
  
  assertthat::assert_that(category %in% c("dip", "sen", "presi"), 
                          msg = "Please select a correct 'category'. Check them with 'show_available_elections()' //
Por favor seleccione una 'catgeory' correcta. Compruebelas con 'show_available_elections()'")
  
  
  # level check

  assertthat::assert_that(is.character(level),
                          msg = "'level' must be a character string. Options = c('provicina', 'departamento', 'circuito') // 
'level' tiene que ser un character string. Opciones = c('provincia', 'departamento', 'circuito')")
  
  assertthat::assert_that(level %in%  c('provincia', 'departamento', 'circuito'), 
                          msg = "Please select a correct 'level'. Check them with 'show_available_elections'() //
Por favor seleccione un 'level' correcto. Compruebelos con 'show_available_elections()'")
  
  
  # district check
  
  assertthat::assert_that(!is.null(district), 
                          msg = "You must provide valid character parameters for 'district', 'category' and 'round', and an integer parameter for 'year'. Check them with 'show_available_elections()' //
Debe proporcionar parametros character validos para 'district', 'category' y 'round', y un parametro integer para 'year'. Compruebelos con  'show_available_elections()'")
  
  
  
  assertthat::assert_that(is.character(district),
                          msg = "'district' must be a character string. Check options with 'show_available_elections()' //
Por favor seleccione un 'district' correcto. Compruebelos con 'show_available_elections()')")
  
  assertthat::assert_that(district %in% c("arg",
                                          "caba",
                                          "catamarca",
                                          "chaco",
                                          "chubut",
                                          "cordoba",
                                          "corrientes",
                                          "erios",
                                          "formosa",
                                          "jujuy",
                                          "mendoza",
                                          "misiones",
                                          "neuquen",
                                          "pampa",
                                          "pba",
                                          "rioja",
                                          "rnegro",
                                          "salta",
                                          "santiago",
                                          "scruz",
                                          "sfe",
                                          "sjuan",
                                          "sluis",
                                          "tdf",
                                          "tucuman"), 
                          msg = "Please select a correct 'district.' Check them with 'show_available_elections()' //
Por favor seleccione un 'district' correcto. Compruebelos con 'show_available_elections()")
  
  # round check
   
  assertthat::assert_that(!is.null(round), 
                          msg = "You must provide valid character parameters for 'district', 'category' and 'round', and an integer parameter for 'year'. Check them with 'show_available_elections()' //
Debe proporcionar parametros character validos para 'district', 'category' y 'round', y un parametro integer para 'year'. Compruebelos con  'show_available_elections()'")
  
   
   assertthat::assert_that(is.character(round),
                           msg = "'round' must be a character string. Options = c('paso', 'gral', 'balota') //
'round' debe ser un character string. Opciones = c('paso', 'gral', 'balota')")

   assertthat::assert_that(round %in% c("paso", "gral", "balota"), 
                           msg = "Please select a correct 'round' Check them with 'show_available_elections()' //
Por favor seleccione una 'round' correcta. Compruebelas con 'show_available_elections()'")
  
    
   # raw check


   assertthat::assert_that(is.logical(raw),
                          msg = "'raw' must be logical. Options = c(TRUE, FALSE) //
'raw' debe ser un boleano. Opciones = c(TRUE, FALSE)" )
   

    # Check available elections
   
   
   check_elections <-   polAr::show_available_elections() %>% 
     dplyr::mutate(elections =paste0(district, category, round, year))
   
   
   assertthat::assert_that(glue::glue({district}, {category}, {round}, {year}) %in% check_elections$elections, 
                           msg = "Please choose a valid election. Check them with 'show_available_elections()' //
Por favor seleccione una eleccipn valida. Consultelas con 'show_available_elections()'")
  
  

   
   ### Provincial Electoral codes 
   
   
   
   codProv <- tibble::tibble(name_prov = 
                        c("CABA", "CATAMARCA", "CHACO", "CHUBUT", "CORDOBA", "CORRIENTES","ENTRE RIOS","FORMOSA", 
                          "JUJUY", "LA PAMPA", "LA RIOJA", "MENDOZA", "MISIONES", "NEUQUEN","BUENOS AIRES","RIO NEGRO",
                          "SALTA", "SANTA CRUZ", "SANTA FE", "SANTIAGO DEL ESTERO", "SAN JUAN", "SAN LUIS", "TIERRA DEL FUEGO", "TUCUMAN"), 
                      codprov = 
                        c('01','03','06','07','04','05','08','09',
                          '10','11','12','13','14','15','02','16',
                          '17','20','21','22','18','19','24','23')) 
   
   
   
   
   
  
        # Temp function:  level selection
               
  levels <- function(level = ""){
                 
    # Replace if_elses with case_when 
    dplyr::case_when(
      level == "provincia" ~ c("codprov"), 
      level == "departamento" ~ c("codprov, depto, coddepto"),
      level == "circuito" ~ c("codprov, depto, coddepto, circuito"), 
      T ~c("codprov")
    )
           
               }
               
              levels <- stringr::str_split(string = levels(level = level), pattern = "\\,")
              levels <- stringr::str_squish(levels[[1]])
              
              
              # get import - RAW or with LEVLES of aggregation
              

              
              if(raw == FALSE) {
         
           df <-   readr::read_csv(paste0("https://github.com/electorArg/PolAr_Data/blob/master/data/",
                                             district, "_",
                                             category, "_",
                                             round,
                                             year, ".csv?raw=true"), 
                                   col_types = readr::cols()) %>% 
               dplyr::group_by_at(levels) %>% 
               dplyr::summarise_if(is.numeric, .funs = sum) %>% 
               dplyr::ungroup() %>%
               dplyr::mutate(codprov = as.character(codprov)) %>% 
               dplyr::left_join(codProv, by = "codprov") %>% 
               dplyr::mutate(category = category,
                             round = round, 
                             year = year) %>% 
               dplyr::group_by_at(levels)
              
             
             
             } else {
                
                
           df <- readr::read_csv(paste0("https://github.com/electorArg/PolAr_Data/blob/master/data/",
                                             district, "_",
                                             category, "_",
                                             round,
                                             year, ".csv?raw=true"), 
                                 col_types = readr::cols()) %>%
                  dplyr::ungroup() %>% 
                  dplyr::mutate(codprov = as.character(codprov)) %>% 
                  dplyr::left_join(codProv, by = "codprov")%>% 
                  dplyr::mutate(category = category,
                                round = round, 
                                year = year)
                
              }
              
             
              
          # LONG or WIDE options

             if(long == TRUE){
               
              df %>%
                 dplyr::ungroup() %>% 
                 dplyr::mutate(codprov = as.character(codprov)) %>% 
                 polAr::make_long() %>% 
                 dplyr::select(category, round, year, codprov, name_prov, dplyr::everything()) %>% 
                 dplyr::group_by_at(levels)
            
             }else{
            
                df %>%
                 dplyr::ungroup() %>% 
                 dplyr::mutate(codprov = as.character(codprov)) %>% 
                 dplyr::select(category, round, year, codprov, name_prov, dplyr::everything()) %>% 
                 dplyr::group_by_at(levels)
                 
               }
      }


