
#'Transforma tabla de resultados a formato largo

#'@description
#'Funcion auqiliar que transforma el tibble WIDE de `election_get()` a LONG
#'@param data es el tibble que devuelve `election_get(data = data, LONG = FALSE)`
#'@export

        get_long <-   function(data){
          
         data %>%
            tidyr::pivot_longer(names_to = "listas",
                                values_to = "votos",
                                cols = c(dplyr::matches("\\d$"), blancos, nulos))
          }
