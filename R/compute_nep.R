
#'Calcla Numero Efectivo de Partidos Politicos - NEP  // ENP - Computes Effective Number of Political Parties

#'@description
#'Funcion que calcula el NEP. Indicador que provee un numero "ajustado" de partidos politicos en un sistema de partidos // 
#' Function that computes NEP. Indicator that provides a "tight" number of political parties in a party system
#'@param index un character con la fórmula elegida: "Laakso-Taagepera" -default-,  "Golosov" o ambas// 
#' a character with the chosen formula: "Laakso-Taagepera"-dafault-, "Golosov" or both.
#'@param data la base de datos para hacer el calculo obtenida con 'election_get()' - 
#' *NOTA* el 'level' de 'election_get()' determina el nivel de agregacion sobre el que se computa el NEP: 'provincia', 'departamento' o 'circuito' // 
#' tiblle  downloaded with 'election_get()' needed to compute nep - **NOTE**:  'level' at 'election_get' determines aggregation on which NEP calculation 
#' will be made: province, department or circuit.
#'@details El computo solo se hace a partir de la cantidad de votos de cada lista y no de las bancas. 
#'  The computation is only made from the number of votes for each ballot and not from the corresponding legislativa seats.
#'@details Impementación de las fórmulas 'Golosov' y 'Laakso-Taagepera' 
#' Implementation of the 'Golosov' and 'Laakso-Taagepera' formulas
#'@export

compute_nep <- function(data,
               index = c("Golosov", "Laakso-Taagepera", "All")){
  
    index <- "Laakso-Taagepera"
  
             if(index == "Golosov"){
              
              golosov <- data %>%
               dplyr::mutate(pct = votos/sum(votos)) %>%  # pct votes from total. Depends on agregation level (group_by in election_get())
               dplyr::summarise(value = sum(pct/(pct+max(pct)^2-pct^2))) %>% # NEP FORMULA 
               dplyr::ungroup() %>%
               dplyr::mutate(index = "Golosov")
             
             golosov
             
             
              
            } else if(index == "Laakso-Taagepera"){
              
              laakso <- data %>%
               dplyr::mutate(pct = votos/sum(votos)) %>%  # pct votes from total. Depends on agregation level (group_by in election_get())
               dplyr::summarise(value = 1/sum(pct^2)) %>%  # NEP FORMULA
               dplyr::ungroup() %>%   
               dplyr::mutate(index = "Laakso-Taagepera")
             
             laakso 
              
            } else {
              
              nep1 <-  data %>%
                dplyr::mutate(pct = votos/sum(votos)) %>%  
                dplyr::summarise(value = sum(pct/(pct+max(pct)^2-pct^2))) %>% 
                dplyr::mutate(index = "Golosov")
              
              
              nep2 <- data %>%
                dplyr::mutate(pct = votos/sum(votos)) %>% 
                dplyr::summarise(value = 1/sum(pct^2)) %>%  
                dplyr::mutate(index = "Laakso-Taagepera")
              
              
              all <- dplyr::bind_rows(nep1, nep2)
              
              
              all
    
  }
  
}
