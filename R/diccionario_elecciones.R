#'Diccionario de Elecciones
#'@description
#'Funcion que devuelve un tibble con los parametros para llamar elecciones con funcion `election_get()`
#'@param `viewer` Por default es `FALSE`. Cuando `TRUE` devuelve una tabla en el Viewer


diccionario_elecciones<- function(viewer = FALSE){

  if(viewer == TRUE){

     x <-  readr::read_csv("data_raw/tabulado_elecciones.csv") %>%
    formattable::formattable()

     print(x)


     } else {
       readr::read_csv("data_raw/tabulado_elecciones.csv")
  }


}

