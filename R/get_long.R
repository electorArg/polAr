
#'Transforma tibble a formato largo // transform tibble into long format

#'@description
#'Funcion auxiliar que transforma el tibble WIDE obtenido con `election_get()` a LONG // Auxiliary function that transforms a WIDE tibble obtained with `election_get ()` to LONG format
#'@param data es el tibble que devuelve `election_get(data = data, LONG = FALSE)`// `election_get (data = data, LONG = FALSE)` output tibble
#'@export

        get_long <-   function(data){
          
         data %>%
            tidyr::pivot_longer(names_to = "listas",
                                values_to = "votos",
                                cols = c(dplyr::matches("\\d$"), blancos, nulos))
          }
