# PolA(R)

## POLítica ARgentina usando `R`

<img src="https://github.com/electorArg/polAr/blob/master/hex/hex-polAr.png?raw=true" width="200">


{polAr} brinda herramientas que facilitan el flujo de trabajo para el análisis político - electoral y el acceso a datos de Argentina desde `R` (*{polAr} provides tools that facilitate the workflow for political-electoral analysis and access to data from Argentina from `R`*). 

<!-- badges: start -->

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/polAr)](https://cran.r-project.org/package=polAr)

[![CRAN_time_from_release](https://www.r-pkg.org/badges/ago/polAr)](https://cran.r-project.org/package=polAr)

[![metacran downloads](https://cranlogs.r-pkg.org/badges/polAr)](https://cran.r-project.org/package=polAr)

[![Travis build status](https://travis-ci.org/electorArg/polAr.svg?branch=master)](https://travis-ci.org/electorArg/polAr)

<!-- badges: end -->


---

### INSTALACIÓN (*Install*)

*CRAN*

```r
install.packages("polAr")

```
---

Sus principales funciones son (*Its main functions are*):

#### EXPLORAR DATOS (*Data explorer*)

- **`show_available_elections()`**: Diccionario de elecciones disponibles. El parámetro `viewer = TRUE` habilita una tabla en el _Viewer_ de `RStudio` (*Dictionary of available elections. The `viewer = TRUE` parameter enables a table in the _Viewer_ of` RStudio`*).


- **`show_available_speech()`**: Diccionario de discursos presidenciales disponibles. El parámetro `viewer = TRUE` habilita una tabla en el _Viewer_ de `RStudio` (*Dictionary of available elections. The `viewer = TRUE` parameter enables a table in the _Viewer_ of` RStudio`*).


#### OBTENER DATOS (*Get data*)


- **`get_election_data()`**: Descarga bases de resultados electorales con parámetros obligatorios y otros optativos (*Download electoral data with mandatory and other optional parameters*). 

Entre los primeros se deben consignar `district` para el distrito; `category` para la catgoría; `round` para el turno e `year` para el año de la elección. Entre los segundos se puede agregar `level`para el nivel de agregación -`"provincia"`, `"departamento"`, `"circuito"`- y `long` para el formato de los datos alargados donde las listas no van cada una en una columna sino como valores de una variable `listas` (*Among the first, `district`; `category`;`round` and` year`  must be consigned. Between the seconds you can add `level` for the level of aggregation -`"province" `,`"department"`,`"circuit"`- and` long` for long formatted data where party lists do not go in columns but as values of a `lists` variable*).

- **`get_multiple_elections()`**: Descarga múltiples bases de resultados electorales simultáneamente (*Download multiple electoral data in one call*). 

- **`get_speech()`**: Descarga contenido de discurso presidencial. El parámetro `raw = TRUE` devuelve un data.frame con una columna discurso con el texto crudo. Caso contrario una versión del discurso _tidy_ -con limpieza de datos y un _token_ por fila (*Download content of presidential speech. The `raw = TRUE` parameter returns a data.frame with a 'discurso' column with the raw text. Otherwise it returns a _tidy_ speech version with clean dataand one _token_ per row*). 


#### CÁLCULOS (*Computation*)
- **`compute_competitiveness()`**: Calcula el nivel de competencia en una elección. Un parámetro `level` permite calcularlo para los distintos niveles de agregación presentes en la `data` (*Computes the level of competition in an election. A parameter `level` allows to calculate it for the different levels of aggregation present in the` data`*).

- **`compute_nep()`**: Calcula el  *Numero Efectivo de Partidos Politicos*. Es sensible al nivel de agregación de la `data` obtenida (*Computes the  'Effective Number of Political Parties'. It is sensitive to the level of aggregation of the obtained `data`*). 

- **`compute_seats()`**: Calcula el número esperado de escaños que debería recibir cada partido en función de los votos obtenidos (*Computes expected parties legislatives seats*). 


#### VISUALIZACIÓN (*Viz*)

- **`tabulate_results()`**: Genera una tabla con resultados agregados. Es posible obtener código \LaTeX de la tabla (*Generate a table with aggregated results. It is possible to get \LaTeX code from the table*).

- **`plot_results()`**: Grafica los resultados de una elección. Es sensible al nivel de agregación de la `data` obtenida (*Plots the results of an election. It is sensitive to the level of aggregation of the obtained `data`*).

- **`map_results()`**: Georeferencia los resultados de una elección (*Maps the results of an election*).

- **`plot_speech()`**: Grafica la frecuencia relativa de palabras en los discursos presidenciales (*Plots presidential speeches words frequency*).


### VIGNETTES

Se pueden consultar pequeños ejemplos de uso en las sección [ARTICULOS](https://electorarg.github.io/polAr/articles/) (*Small examples of use can be found in the ARTICLES section*).

* [Data Access](https://electorarg.github.io/polAr/articles/data.html)

* [Computing](https://electorarg.github.io/polAr/articles/compute.html)

* [Displaying Results](https://electorarg.github.io/polAr/articles/results.html)


### Versión en desarrollo (*Development version*) 

```r

# install.packages('devtools') si no tiene instalado devtools

devtools::install_github("electorArg/polAr")

```

Los cambios y nuevas funciones en el desarrollo del paquete pueden consultarse en detalle en [*changelog*](https://electorarg.github.io/polAr/news/index.html) (*Changes in package development can be found in detail in the [changelog](https://electorarg.github.io/polAr/news/index.html)*).


### REFERENCIA (*Reference*)

```r
Juan Pablo Ruiz Nicolini (2020). polAr: Argentina Political Analysis. R package version
  0.1.3.2. https://github.com/electorArg/polAr
```

```r
@Manual{,
    title = {polAr: Política Argentina usando R},
    author = {Juan Pablo {Ruiz Nicolini}},
    year = {2020},
    note = {R package version 0.0.0.9000},
    url = {https://github.com/electorArg/polAr},
  }


```

### CREDITOS (*Credits*)

- Las liberías [`eph`](https://github.com/holatam/eph), [`electoral`](https://CRAN.R-project.org/package=electoral) y [`esaps`](https://nicolas-schmidt.github.io/esaps/index.html) fueron inspiración y fuente de este proyecto (*Libraries [`eph`](https://github.com/holatam/eph), [`electoral`](https://CRAN.R-project.org/package=electoral) and [`esaps`](https://nicolas-schmidt.github.io/esaps/index.html) were inspiration for this project.)*) 

- La gran mayoría de los datos electorales proviene de las bases en archivos `.mdb` del [_Atlas Electoral de Andy Tow_](https://www.andytow.com/access/index.php?logout=true) (*Access to raw data comes from databases in `.mdb` files of [Andy Tow Electoral Atlas](https://www.andytow.com/access/index.php?logout=true)*).



### DATOS (*Data*)

(**Trabajo en proceso - Work in progress**)

#### Electorales
 
- La primera etapa de este proyecto consistió en un procesamiento de esos archivos para convertirlos a otros con formato `sqlite` para manipularlos más facilmente desde `R`(*The first stage of this project consisted in processing those files and convert them to others in `sqlite` format for easier manipulation with `R`*).

- Con esa información generamos cuadernos de `RMarkdown` para hacer las consultas de resultados para distintos años, cateogrías, turnos electorales y distrito. Pronto una descripción más detallada y documentación de este proceso (*With this information, we generate `RMarkdown` notebooks to query the results for different years, categories, electoral turns and district. Soon a more detailed description and documentation of this process*). 

#### Discursos

Con el aporte de [Lucas Enrich](https://twitter.com/lucasenrich) y [Camila Higa](https://twitter.com/chig4_) trabajamos sobre una base de datos de discursos de apertura de sesiones legislativas de los presidentes argentinos: desde el primer discurso de Justo José de Urquiza en 1854 hasta el de Alberto Fernández en 2020.  Se disponibilizan versiones de texto con mínimo procesamiento y otras en formato [tidy](https://www.tidytextmining.com/tidytext.html), siguiendo la definición de Julia Silge y David Robinson.   


 
### TWITTER BOT

Junto a [Camila Higa](https://twitter.com/chig4_) trabajamos en un robot de twitter - [pol_ar_bot](https://twitter.com/pol_Ar_bot) - que se monta sobre `polAr` y responde consultas de usuaries sobre resultados de elecciones combinando las funciones `get_election_data()` y `plot_results()`. 

