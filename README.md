# PolA(R)

## POLítica ARgentina usando `R`

<img src="https://github.com/electorArg/polAr/blob/master/hex/hex-polAr.png?raw=true" width="200">


La idea del paquete es brindar herramientas que faciliten el acceso a datos y el flujo de trabajo para el análisis político - electoral, con ejempos aplicados de Argentina. 

Se espera tener pronto el acceso a datos para todas las elecciones nacionales (diputados, senaodres y presidente) desde el año 2003 a 2019 al nivel disponible de desagregación mayor (mesas). Asimismo incorporar nuevas funciones para calcular indicadores y herramientas de visualización de datos. 


---

**(Esta es una versión _beta_ del proyecto que dejamos abierto a comentarios y/o sugerencias)**. 

### INSTALACIÓN

_Versión en desarrollo_. 

```r

# install.packages('devtools') si no tiene instalado devtools

devtools::install_github("electorArg/polAr")

```

Sus principales funciones son:

- **`get_election_data()`**: Descarga bases de resultados electorales con parametros obligatorios y otros optativos. 

Entre los primeros se deben consignar `district` para el distrito; `category` para la catgoría; `round` para el turno e `year` para el año de la elección. Entre los segundos se puede agregar `level`para el nivel de agregación (`"provincia"`, `"departamento"`, `"circuito"`) y `long` para el formato de los datos alargados (las listas no van cada una en una columna sino como valores de una variable `listas`). 

- **`show_available_elections()`**: Diccionario de Elecciones disponibles. El parametro `viewer = TRUE` habilita una tabla en el _Viewer_ de `RStudio`.

- **`get_names()`**: Obtiene nombres de listas (funciona correctamente cuando los datos fueron obtenidos _LARGOS_: `election_get(data, ...,  long = T)`

- **`compute_nep()`**: Calcula el  *Numero Efectivo de Partidos Politicos*. Es sensible al nivel de agregación de la `data` obtenida. 

- **`compute_competitiveness()`**: Calcula el nivel de competencia en una elección (0 , 1). Un parámetro `level` permite calcularlo para los distintos niveles de agregación presentes en la `data`.  



### EJEMPLO DE USO

1. La función `show_available_elections()` muestra las elecciones disponibles para descarga. Por defecto el parámetro `viewer = FALSE` imprime el resultado en consola. Si en cambio escribimos `viewer = TRUE` los datos se presentan en el _Viewer_ de `RStudio` y quedan a mano como tabla formateada y con la capacidad de ordenar y filtrar valores. 

```r

library(polAr)

show_available_elections()

# A tibble: 21 x 4
#  Distrito   Categoria Turno Anio 
#  <chr>      <chr>     <chr> <chr>
#    1 arg        presi     paso  2011 
#  2 caba       dip       paso  2011 
#  3 catamarca  dip       gral  2015 
#  4 chubut     dip       paso  2013 
#  5 cordoba    sen       paso  2015 
#  6 corrientes dip       gral  2017 
#  7 erios      dip       gral  2013 
#  8 formosa    dip       gral  2011 
#  9 jujuy      sen       gral  2017 
#  10 neuquen    dip       gral  2013 
# ... with 11 more row

```
2. `get_election_data` es la función principal para hacernos de los datos disponibles. Los parámetros obligatorios son los que definen el distrito (`district`), la categoría (`category`), el turno (`round`) y el año electoral (`year`). 

Por defecto los datos colapsan a nivel provincial, pero podemos definir otros niveles como departamento o circuito electoral con el parámetro `levels`. 

También por defecto los datos se descargan en formato ancho (*wide*). Pero se incluye otro parametro para cambiar a un formato largo (*long*) usando `long = TRUE`. 

Abajo el resultado de la consulta solo con los parámetros obligatorios, en el primer caso, y con un nivel de desagregación menor en el segundo:

```r
get_election_data(district = "caba", category = "dip", round = "paso", year = "2011")


# A tibble: 1 x 19
# Groups:   codprov [1]
#  codprov electores blancos nulos `0023` `0036` `0179` `0302` `0501` `0504` `0508` `0509` `0510` `0517` `0518` `0536` category round year 
#  <chr>       <dbl>   <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <chr>    <chr> <chr>
#  1 01      91166   35478 27459 186276  68575   8234  68001 509590  95714  47956 145580 201173  81666 294312 135361 dip      paso  2011 

get_election_data(district = "caba", category = "dip", round = "paso", year = "2011", 
                  level = "departamento" )

# A tibble: 15 x 21
# Groups:   codprov, depto, coddepto [15]
# codprov depto coddepto electores blancos nulos `0023` `0036` `0179` `0302` `0501` `0504` `0508` `0509` `0510` `0517` `0518` `0536` category round
# <chr>   <chr> <chr>        <dbl>   <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <chr>    <chr>
#   1 01      Comu~ 001         185778    2403  1832  13071   5425    563   3784  37804   6829   2876   8847  10629   5094  21335   9064 dip      paso 
# 2 01      Comu~ 002         149091    1514  1516  10819   4228    318   3454  17102   5728   1947   5091  10459   3241  29611  13378 dip      paso 
# 3 01      Comu~ 003         167025    2538  1985  11506   4623    548   4455  35901   6758   3469   9229  11750   5871  13997   7181 dip      paso 
# 4 01      Comu~ 004         175190    2897  2040  11965   4891    601   4323  47381   7012   3178  10902  10436   5956  17230   5879 dip      paso 
# 5 01      Comu~ 005         152903    1944  1743  10794   3997    533   4388  34081   6412   3220   8769  14543   5858  14325   7900 dip      paso 
# 6 01      Comu~ 006         153077    1981  1651  11655   3729    527   4490  27769   6681   3361   7959  17016   5924  17983   9702 dip      paso 
# 7 01      Comu~ 007         169698    2522  1928  13003   4722    617   5064  37849   6908   3396  10880  14229   5888  16926   8011 dip      paso 
# 8 01      Comu~ 008         133174    2297  1468   9796   4124    493   2669  41678   4043   1833  10850   5714   3453  10917   3484 dip      paso 
# 9 01      Comu~ 009         144877    2521  1553  11728   4246    610   3709  36870   5013   2865  12124  10096   4696  13601   5509 dip      paso 
#10 01      Comu~ 010         145632    2722  1647  11564   3757    654   4652  31437   5741   3420  11306  12537   5431  14618   6955 dip      paso 
#11 01      Comu~ 011         166687    2500  1913  13105   4488    611   5269  32842   6528   3683  11312  15711   5953  19022   8811 dip      paso 
#12 01      Comu~ 012         172984    2461  1991  13233   4858    567   5386  34576   6477   3857  11321  15376   6333  21860   9568 dip      paso 
#13 01      Comu~ 013         208929    2366  2156  17286   5828    535   5916  28647   7959   3790   9054  19433   5906  35143  15953 dip      paso 
#14 01      Comu~ 014         204174    2474  2043  16197   5585    476   5332  30031   7710   3597   8098  17938   5643  33046  16279 dip      paso 
#15 01      Comu~ 015         161947    2338  1993  10554   4074    581   5110  35622   5915   3464   9838  15306   6419  14698   7687 dip      paso 
# ... with 1 more variable: year <chr>
```

3.  Si bien se puede usar el parametro `long = T` a la hora de descargar los datos, también podemos usar `get_long()` para conseguir la misma transformación si los datos ya habían sido guardados como un objeto en formato ancho (*wide*). 

Este sería el caso si la llamada anterior hubiese sido guardada en un objeto llamado `data`:  


`data <- get_election_data(district = "caba", category = "dip", round = "paso", year = "2011", level = "departamento" )`


```r
data %>% 
  get_long() 

# A tibble: 210 x 9
# Groups:   codprov, depto, coddepto [15]
#  codprov    depto     coddepto electores category round year  listas votos
#  <chr>     <chr>     <chr>        <dbl> <chr>    <chr> <chr> <chr>  <dbl>
#  1 01      Comuna 01 001         185778 dip      paso  2011  0023   13071
#  2 01      Comuna 01 001         185778 dip      paso  2011  0036    5425
#  3 01      Comuna 01 001         185778 dip      paso  2011  0179     563
#  4 01      Comuna 01 001         185778 dip      paso  2011  0302    3784
#  5 01      Comuna 01 001         185778 dip      paso  2011  0501   37804
#  6 01      Comuna 01 001         185778 dip      paso  2011  0504    6829
#  7 01      Comuna 01 001         185778 dip      paso  2011  0508    2876
#  8 01      Comuna 01 001         185778 dip      paso  2011  0509    8847
#  9 01      Comuna 01 001         185778 dip      paso  2011  0510   10629
# 10 01      Comuna 01 001         185778 dip      paso  2011  0517    5094
# ... with 200 more rows
```

4. Siguiendo el ejemplo anterior, una vez que `data` cambió a formato *long* se puede incorporar facilmente el nombre de los partios correspondientes al *id* de la columna `listas` con `get_names()`: 

```r

data %>% 
  get_long() %>% 
  get_names() 

# A tibble: 210 x 10
# Groups:   codprov, depto, coddepto [15]
# codprov   depto     coddepto electores category round year  listas votos nombre_lista                                     
# <chr>     <chr>     <chr>     <dbl>    <chr>    <chr> <chr> <chr>  <dbl> <chr>                                            
# 1 01      Comuna 01  001      185778    dip      paso  2011  0023   13071 UNION POPULAR                                    
# 2 01      Comuna 01  001      185778    dip      paso  2011  0036    5425 AUTONOMISTA                                      
# 3 01      Comuna 01  001      185778    dip      paso  2011  0179     563 ACCION CIUDADANA                                 
# 4 01      Comuna 01  001      185778    dip      paso  2011  0302    3784 DE LA CIUDAD EN ACCION                           
# 5 01      Comuna 01  001      185778    dip      paso  2011  0501   37804 ALIANZA FRENTE PARA LA VICTORIA                  
# 6 01      Comuna 01  001      185778    dip      paso  2011  0504    6829 ALIANZA UNION PARA EL DESARROLLO SOCIAL          
# 7 01      Comuna 01  001      185778    dip      paso  2011  0508    2876 ALIANZA PROYECTO SUR                             
# 8 01      Comuna 01  001      185778    dip      paso  2011  0509    8847 COMPROMISO FEDERAL                               
# 9 01      Comuna 01  001      185778    dip      paso  2011  0510   10629 FRENTE AMPLIO PROGRESISTA                        
#10 01      Comuna 01  001      185778    dip      paso  2011  0517    5094 ALIANZA FRENTE DE IZQUIERDA Y DE LOS TRABAJADORES
# ... with 200 more rows


```
5. La libería incluye funciones para computar indicadores relevantes. Así, por ejemplo, puede calcularse el *Número Efectivo de Partidos Políticos*. 

El cálculo se realizará el nivel de agregación de los datos descargados con `get_election_data()`. En este caso a nivel departamental. La función `compute_nep()` tiene un parámetro para elegir entre el índice de [Laakso-Taagepera](https://journals.sagepub.com/doi/10.1177/001041407901200101) y/o el de  [Golosov](https://journals.sagepub.com/doi/10.1177/1354068809339538).


```r
data %>% 
  get_long() %>% 
  compute_nep() 
  
#   # A tibble: 15 x 5
#    codprov depto     coddepto value index           
#    <chr>   <chr>     <chr>    <dbl> <chr>           
#   1 01    Comuna 01  001       6.82 Laakso-Taagepera
#   2 01    Comuna 02  002       6.99 Laakso-Taagepera
#   3 01    Comuna 03  003       7.05 Laakso-Taagepera
#   4 01    Comuna 04  004       5.86 Laakso-Taagepera
#   5 01    Comuna 05  005       7.16 Laakso-Taagepera
#   6 01    Comuna 06  006       8.02 Laakso-Taagepera
#   7 01    Comuna 07  007       7.18 Laakso-Taagepera
#   8 01    Comuna 08  008       4.85 Laakso-Taagepera
#   9 01    Comuna 09  009       6.44 Laakso-Taagepera
#  10 01    Comuna 10  010       7.58 Laakso-Taagepera
#  11 01    Comuna 11  011       7.84 Laakso-Taagepera
#  12 01    Comuna 12  012       7.71 Laakso-Taagepera
#  13 01    Comuna 13  013       7.85 Laakso-Taagepera
#  14 01    Comuna 14  014       7.74 Laakso-Taagepera
#  15 01    Comuna 15  015       7.18 Laakso-Taagepera
 

```
 
 
 
 


### CREDITOS

- Las liberías [`eph`](https://github.com/holatam/eph), [`electoral`](https://cran.r-project.org/web/packages/electoral/index.html) y [`esaps`](https://nicolas-schmidt.github.io/esaps/index.html) fueron inspiración de este proyecto. 

- El acceso a los datos en bruto viene de las bases en archivos `.mdb` del [_Atlas Electoral de Andy Tow_](https://www.andytow.com/access/index.php?logout=true). 

- La primera etapa de este proyecto consistió en un procesamiento de esos archivos para convertirlos a otros con formato `sqlite` para manipularlos más facilmente desde `R`. 

- Con esa información generamos cuadernos de `RMarkdown` para hacer las consultas de resultados para distintos años, cateogrías, turnos electorales y distrito (pronto una descripción más detallada y documentación de este proceso). 

### REFERENCIA

```r
@Manual{,
    title = {polAr: Explora Datos Electorales de Argentina},
    author = {Juan Pablo {Ruiz Nicolini}},
    year = {2020},
    note = {R package version 0.0.0.9000},
    url = {https://github.com/electorArg/polAr},
  }


```
 
