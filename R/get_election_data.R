#'Descarga bases de resultados electorales // Download electoral data 

#'@description
#'Funcion que descarga resultados electorales nacionales desde 2007 //
#'Function that downloads national electoral data since 2007
#'@param district un character con codigo para Argentina y las 24 provincias //
#' a named character with code for Argentina and the 24 provinces
#'@param category un character para la categoria electoral: diputado -dip-, senador -sen- o presidente -presi //
#' a character with a name for the electoral category: deputy-dip-, senator -sen- or president -presi.
#'@param year un integer para el year de eleccion // an integer for the year of choice
#'@param round un character para tipo de eleccion: primaria -paso- o general -gral- // 
#' a character with a name for the election round: primary -paso- or general -gral.
#'@param level un character para seleccionar level de agregacion de los resultados: provincia, departamento o circuito //
#' a character to select the level of aggregation of the results: province -provincia-, department -departamento or electoral precints -circuito. 
#'@param long un boleano para estructura de los datos. Por default long == FALSE // a boolean for data structure. By default long == FALSE
#'@param raw un boleano para que define si descargar base de datos desagregada a nivel MESA o no con valor default == FALSE // 
#'a boolean to define whether to download a disaggregated data at  BALLOT level or not with default == FALSE



#'@export

get_election_data <- function(district = NULL ,
                              category = NULL,
                              round = NULL ,
                              year = NULL,
                              level = "provincia",
                              long = FALSE, 
                              raw = FALSE){
  
  
  # Check for internet coection
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "No se detecto acceso a internet. Por favor checkea tu conexion.")
  
  # Check params 

  # year check
  assertthat::assert_that(is.numeric(year), 
                          msg = "Please select a correct 'year'. Check them with show_available_elections()")
  
  # category check
  assertthat::assert_that(is.character(category),
                          msg = "Please select correct category. Check them with show_available_elections()")
  
  assertthat::assert_that(category %in% c("dip", "sen", "presi"), 
                          msg = "Please select correct category. Check them with show_available_elections()")
  
  
  # district check
  assertthat::assert_that(is.character(district), msg = "Please select correct district Check them with show_available_elections()")
  
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
                          msg = "Please select correct district. Check them with show_available_elections()")
  
  # round check
   assertthat::assert_that(is.character(round), msg = "Please select correct round Check them with show_available_elections()")

   assertthat::assert_that(round %in% c("paso", "gral", "balota"), 
                           msg = "Please select correct category. Check them with show_available_elections()")
   
  
  
  #controles de los parametros
 
  
  
  
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
              
              
              #READ DATA - RAW or with LEVLES of aggregation
              
              
              
              if(raw == FALSE) {
         
           df <-   readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
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
              
             
             
             } else {
                
                
           df <-     readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
                                             district, "_",
                                             category, "_",
                                             round,
                                             year, ".csv?raw=true")) %>% 
                  dplyr::mutate(category = category,
                                round = round, 
                                year = year)
                
              }
              
             
              
   # LONG OR WIDE OPTION

             if(long == TRUE){
               
              df %>% get_long()
            
             }else{
            
                df
               }
      }


