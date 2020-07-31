#'Carga poligonos geográficos de distritos de  Argentina
#'@description
#'Función que descaga (\emph{geometry}) para graficar con mapas
#' 
#' 
#' @examples 
#' 
#' get_geo("TUCUMAN")
#'
#'@param geo un character con el nombre del district que se quiere descargar. Se pueden chequear el id con \code{\link{show_arg_codes}}.
#'@param level parametro opcional para descargar geometrías a nivel 'departamento' cuando se solicita mapa nacional \code{get_geo(geo = "ARGNTINA", level = "departamento")}.
#'@export

get_geo <- function(geo = NULL, 
                    level = "departamento") {
  
  # ARG MAP
  if(geo == "ARGENTINA") {
      
    assertthat::assert_that(level %in% c("departamento", "provincia"),
                            msg = "National geography can be downloaded only at 'departamento' or 'provincia' level" )
    
    if(level == "departamento"){
     
      sf::read_sf("https://github.com/electorArg/PolAr_Data/raw/master/geo/departamentos.geojson") %>% 
        dplyr::rename(coddepto = coddept) %>% 
        dplyr::select(-depto)
          
    } else {
      
      sf::read_sf("https://github.com/electorArg/PolAr_Data/raw/master/geo/provincias.geojson") 
      
  # PROVINCES MAPS
     
    }
    
    } else {
    
    temp <- polAr::show_arg_codes(viewer = FALSE) %>% 
      dplyr::filter(id == geo) %>% 
      dplyr::pull(codprov)

   sf::read_sf("https://github.com/electorArg/PolAr_Data/raw/master/geo/departamentos.geojson") %>% 
      dplyr::rename(coddepto = coddept) %>% 
      dplyr::select(-depto) %>% 
      dplyr::filter(codprov %in% temp)
    
    }
  
  }
