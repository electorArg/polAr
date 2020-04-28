#'Descarga de Bases de resultados electorales al nivel de MESA  // Download electoral data at BALLOT level

#'@description
#'Funcion que descarga bases de resultados electorales nacionales desde el 2007 al nivel de mayor desagregacion *MESA*//
#'Function that downloads national raw data since 2007 national election at "BALLOT" level
#'@param district un character con nombre codigo para seleccionar distrito: argentina y las 24 provincias // 
#'a character with name code to select district: Argentina and the 24 provinces
#'@param category un character para la categoria electoral: diputado -'dip' ; senador - 'sen' ; presidente - 'presi' // 
#'a character for the electoral category: deputy -'dip '; senator - 'sen'; president - 'presi'
#'@param round un integer para el anio de eleccion //  an integer for the year of choice
#'@param year tipo de eleccion: primaria -'paso'- o general -'gral'- // election round: primary -'paso'- or general -'gral'
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
#'  
#    # A tibble: 7,189 x 20
#   codprov    depto coddepto circuito mesa  electores blancos nulos `0023` `0036` `0179` `0302` `0501` `0504` `0508` `0509` `0510` `0517`
#   <chr>      <chr> <chr>    <chr>    <chr>     <dbl>   <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
#   1 01      Comu~ 001      0001     0001        347       2     4     26      4      0     11     88     13      3     13     19     12
#   2 01      Comu~ 001      0001     0002        345       5     1     10     10      0     15     74     12      5     15     35     16
#   3 01      Comu~ 001      0001     0003        345       4     3     22      6      2      6     92     14      8     17     28     12
#   4 01      Comu~ 001      0001     0004        345       4     5     32      1      2      7     94      9     10     20     32      8
#   5 01      Comu~ 001      0001     0005        343       4     8     23     10      3      7     81      8     10     14     33     10
#   6 01      Comu~ 001      0001     0006        344       2     5     18     15      3     11     84     10      9     17     29     10
#   7 01      Comu~ 001      0001     0007        344       1     5     21      6      2      9     85      9      0     21     21     19
#   8 01      Comu~ 001      0001     0008        345       9     6     22      8      3     11     94     16      3     12     20     14
#   9 01      Comu~ 001      0001     0009        345       2     6     18     10      2     11     75     17     11     23     29     15
#  10 01      Comu~ 001      0001     0010        347       0     0     11     12      0     10     80     19      4     11     25     15
#   # ... with 7,179 more rows, and 2 more variables: `0518` <dbl>, `0536` <dbl>
# 


#'@export

election_get_raw <- function(district,
                         category,
                         round,
                         year){
  
  
    readr::read_csv(paste0("https://github.com/TuQmano/test_data/blob/master/",
                           district, "_",
                           category, "_",
                           round,
                           year, ".csv?raw=true"))
    
  }

