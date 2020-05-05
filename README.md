# PolA(R)

## POLítica ARgentina usando `R`

<img src="https://github.com/electorArg/polAr/blob/master/hex/hex-polAr.png?raw=true" width="200">


Este paquete brinda herramientas que facilitan el flujo de trabajo para el análisis político - electoral y el acceso a datos de Argentina desde `R`. 

**(Esta es una versión _beta_ del proyecto que dejamos abierto a comentarios y/o sugerencias)**. 

Se espera pronto tene una primera versión completa con los datos disponible para todas las elecciones nacionales (diputados, senadores y presidente) desde el año 2003 a 2019, al mayor nivel de desagregación posible (mesas). Asimismo incorporar nuevas funciones para calcular indicadores y herramientas de visualización de datos. 


---



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

#### Explorar datos disponibles con `show_available_elections()`

La función `show_available_elections()` muestra las elecciones disponibles para descarga. Por defecto el parámetro `viewer = FALSE` imprime el resultado en consola. Si en cambio escribimos `viewer = TRUE` los datos se presentan en el _Viewer_ de `RStudio` y quedan a mano como tabla formateada y con la capacidad de ordenar y filtrar valores. 

```r

library(polAr)

show_available_elections()

# A tibble: 21 x 4
   district   category round year 
   <chr>      <chr>    <chr> <chr>
 1 arg        presi    paso  2011 
 2 caba       dip      paso  2011 
 3 catamarca  dip      gral  2015 
 4 chubut     dip      paso  2013 
 5 cordoba    sen      paso  2015 
 6 corrientes dip      gral  2017 
 7 erios      dip      gral  2013 
 8 formosa    dip      gral  2011 
 9 jujuy      sen      gral  2017 
10 neuquen    dip      gral  2013 
# ... with 11 more rows

```


#### Obtener datos con `get_election_data()`

`get_election_data()` es la función principal para hacernos de los datos disponibles. Los parámetros obligatorios son los que definen el distrito (`district`), la categoría (`category`), el turno (`round`) y el año electoral (`year`). 

Por defecto los datos colapsan a nivel provincial, pero podemos definir otros niveles como departamento o circuito electoral con el parámetro `levels`. 

Abajo el resultado de la consulta solo con los parámetros obligatorios, en el primer caso, y con un nivel de desagregación menor en el segundo:

```r
get_election_data(district = "caba", category = "dip", round = "paso", year = "2011")


# A tibble: 1 x 19
# Groups:   codprov [1]
#  codprov electores blancos nulos `0023` `0036` `0179` `0302` `0501` `0504` `0508` `0509` `0510` `0517` `0518` `0536` category round year 
#  <chr>       <dbl>   <dbl> <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <chr>    <chr> <chr>
#  1 01      91166   35478 27459 186276  68575   8234  68001 509590  95714  47956 145580 201173  81666 294312 135361 dip      paso  2011 

```

#### Transformar estructura de datos anchos (*wide*) a largos (*long*) con `get_long()`

También por defecto los datos se descargan en formato *wide*. Pero se incluye la opción de cambiar a un formato *long* usando `long = TRUE` como parametro de `get_election_data(... , long = T)` a la hora de descargar los datos.  

Otra alternativa es usar la función auxiliar `get_long()` para conseguir la misma transformación,  si los datos ya habían sido guardados como un objeto en formato ancho (*wide*). 

Este sería el caso haciendo una llamada similar a la del ejemplo anterior pero ahora a nivel `departamento`y guardandola en un objeto con nombre `data`:  


`data <- get_election_data(district = "caba", category = "dip", round = "paso", year = "2011", level = "departamento")`, donde, por defecto `long = FALSE`.


Usamos la función auxiliar para convertir el formato de `data`: 

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

#### Obtener nombres de listas o partidos políticos con `get_names()`

Siguiendo el ejemplo anterior, una vez que `data` cambió a formato *long* se puede incorporar facilmente el nombre de los partios correspondientes al *id* de la columna `listas` con `get_names()`: 

```r

data %>% 
  get_long() %>% 
  get_names() 

```


#### Computar Número Efectivo de Partidos con `compute_nep()`

La libería incluye funciones para computar indicadores relevantes. Así, por ejemplo, puede calcularse el *Número Efectivo de Partidos Políticos*. 

El cálculo se realizará el nivel de agregación de los datos descargados con `get_election_data()`. En este caso a nivel departamental. La función `compute_nep()` tiene un parámetro para elegir entre el índice de [Laakso-Taagepera](https://journals.sagepub.com/doi/10.1177/001041407901200101) y/o el de  [Golosov](https://journals.sagepub.com/doi/10.1177/1354068809339538).


```r
data %>% 
  get_long() %>% 
  compute_nep() 

```
 

### CREDITOS

- Las liberías [`eph`](https://github.com/holatam/eph), [`electoral`](https://CRAN.R-project.org/package=electoral) y [`esaps`](https://nicolas-schmidt.github.io/esaps/index.html) fueron inspiración de este proyecto. 

- El acceso a los datos en bruto viene de las bases en archivos `.mdb` del [_Atlas Electoral de Andy Tow_](https://www.andytow.com/access/index.php?logout=true). 

### DATOS

(**Trabajo en proceso**)

- La primera etapa de este proyecto consistió en un procesamiento de esos archivos para convertirlos a otros con formato `sqlite` para manipularlos más facilmente desde `R`. 

- Con esa información generamos cuadernos de `RMarkdown` para hacer las consultas de resultados para distintos años, cateogrías, turnos electorales y distrito (pronto una descripción más detallada y documentación de este proceso). 

### REFERENCIA

```r
@Manual{,
    title = {polAr: Política Argentina usando R},
    author = {Juan Pablo {Ruiz Nicolini}},
    year = {2020},
    note = {R package version 0.0.0.9000},
    url = {https://github.com/electorArg/polAr},
  }


```
 
