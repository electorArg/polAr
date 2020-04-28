#'Descarga de Bases de resultados electorales al nivel de MESA  // Download electoral data at BALLOT level

#'@description
#'Funcion que descarga bases de resultados electorales nacionales desde el 2007 al nivel de mayor desagregacion *MESA*//
#'Function that downloads national raw data since 2007 national election at "BALLOT" level
#'@param district un character con nombre codigo para seleccionar distrito: argentina y las 24 provincias // 
#'a character with name code to select district: Argentina and the 24 provinces
#'@param category un character para la categoria electoral: diputado -'dip' ; senador - 'sen' ; presidente - 'presi' // 
#'a character for the electoral category: deputy -'dip '; senator - 'sen'; president - 'presi'
#'@param round un integer para el anio de eleccion //  
#'an integer for the year of choice
#'@param year tipo de eleccion: primaria -'paso'- o general -'gral'- // 
#'election round: primary -'paso'- or general -'gral'
#
#
#'@return Un tibble con los resultados a nivel *MESA* para el distrito, turno, tipo y anio de la eleccion. Con variables id 
#' de provincia -'codprov'-, departamento - 'depto' y 'coddepto'-, circuito electoral -'circuito'-, y mesa de votacion -'mesa'. Ademas 
#' de una columna por cada lista que participo en la eleccion - con su cordgo numerico-, votos en blanco -'blancos'-, nulos -'nulos'- y
#' cantidad de electores -'electores'.  
#'
#
#
#'@examples
#'
#'      election_get_raw(district = "caba",
#'                      category = "dip",
#'                      round = "paso",
#'                      year = 2011)
#'       
#'    


#'@export




election_get_raw <- function(district,
                         category,
                         round,
                         year){

  
  
  # Check for internet coection
  attempt::stop_if_not(.x = curl::has_internet(), # from eph package
                       msg = "No se detecto acceso a internet. Por favor checkea tu conexion.")
  
    
  
    readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
                           district, "_",
                           category, "_",
                           round,
                           year, ".csv?raw=true"))
    
  }

