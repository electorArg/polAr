
#'Calcla Número Efectivo de Partidos - NEP 

#'@description
#'Funcion que calcula el Numero Efectivo de Partidos - NEP. Indicador que provee un número "ajustado" de partidos políticos en un sistema de partídos
#'@param index un character con la fórmula elegida: "Laakso-Taagepera" o "Golosov" 
#'@param data la base de datos para hacer el calculo descargada con 'election_get' - relevante el 'nivel' de agregación sobre la que se hará el calculo: provincia, departamento o circuito


#'@export

nep <- function(data,
               index = "All"){
  

             if(index == "Golosov"){
              
             golosov <-  data %>%
               dplyr::mutate(pct = votos/sum(votos)) %>%  # votos en porcentaje sobre el total 
               dplyr::summarise(value = sum(pct/(pct+max(pct)^2-pct^2))) %>% dplyr::ungroup() %>%
               dplyr::mutate(index = "Golosov")
             
             golosov
             
             
              
            } else if(index == "Laakso-Taagepera"){
              
             laakso <- data%>%
               dplyr::mutate(pct = votos/sum(votos)) %>%  # votos en porcentaje sobre el total 
               dplyr::summarise(value = 1/sum(pct^2)) %>% dplyr::ungroup() %>%   # formula NEP 
               dplyr::mutate(index = "Laakso-Taagepera")
             
             laakso 
              
            } else {
              nep1 <-  data %>%
                dplyr::mutate(pct = votos/sum(votos)) %>%  # votos en porcentaje sobre el total 
                dplyr::summarise(value = sum(pct/(pct+max(pct)^2-pct^2))) %>% 
                dplyr::mutate(index = "Golosov")
              
              
              nep2 <- data %>%
                dplyr::mutate(pct = votos/sum(votos)) %>%  # votos en porcentaje sobre el total 
                dplyr::summarise(value = 1/sum(pct^2)) %>%  # formula NEP 
                dplyr::mutate(index = "Laakso-Taagepera")
              
              
              all <- dplyr::bind_rows(nep1, nep2)
              
              
              all
    
  }
  
}
