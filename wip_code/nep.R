#### NUMERO EFECTIVO DE PARTIDOS

library(tidyverse)


cols <- ncol(x) 


# PREPARO DATA
x <- readr::read_csv("data_raw/presi_gral2007.csv") %>% 
  group_by(codprov) %>% 
  summarise_if(.is.numeric, funs(sum)) %>% 
  pivot_longer(names_to = "lista", values_to = "votos", cols = c(4:20)) %>% 
  group_by(codprov) %>% 
  select(4, 5)

# CALCULO NEP 

  #Lakso y Taggapera 


eleccion %>%
  mutate(pct = votos/sum(votos)) %>%  # votos en porcentaje sobre el total 
  arrange(desc(pct)) %>% # ordeno de mayor a menor para inspeccionar
  summarise(value = 1/sum(pct^2)) %>%  # formula NEP 
  mutate(index = "Laakso-Taagepera")

# Golosov


eleccion %>%
  mutate(pct = votos/sum(votos)) %>%  # votos en porcentaje sobre el total 
  arrange(desc(pct)) %>% # ordeno de mayor a menor para inspeccionar
  summarise(value = sum(pct/(pct+max(pct)^2-pct^2))) %>% 
  mutate(index = "Golosov")
  


