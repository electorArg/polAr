# PolA(R)

## POLítica ARgentina usando `R`

<img src="https://github.com/electorArg/polAr/blob/master/hex/hex-polAr.png?raw=true" width="200">


{polAr} brinda herramientas que facilitan el flujo de trabajo para el análisis político - electoral y el acceso a datos de Argentina desde `R` (*{polAr} provides tools that facilitate the workflow for political-electoral analysis and access to data from Argentina from `R`*). 

Se espera pronto tener una primera versión completa con los datos disponibles para todas las elecciones nacionales -diputados, senadores y presidente- desde el año 2003 a 2019, al mayor nivel de desagregación -mesas. Asimismo se espera incorporar nuevas funciones para calcular indicadores y herramientas de visualización de datos (*It is expected soon to have a first complete version with the data available for all national elections -deputies, senators and president- from 2003 to 2019, at the highest level of disaggregation -ballot. Also incorporate new functions to compute indicators and data visualization tools*). 


---


### INSTALACIÓN (*INSTALLATION*)

*CRAN*

```r
install.packages("polAr")

```

_Versión en desarrollo (Development version)_. 

```r

# install.packages('devtools') si no tiene instalado devtools

devtools::install_github("electorArg/polAr")

```

Sus principales funciones son (*Its main functions are*):


- **`show_available_elections()`**: Diccionario de elecciones disponibles. El parámetro `viewer = TRUE` habilita una tabla en el _Viewer_ de `RStudio` (*Dictionary of available elections. The `viewer = TRUE` parameter enables a table in the _Viewer_ of` RStudio`*).

- **`get_election_data()`**: Descarga bases de resultados electorales con parámetros obligatorios y otros optativos (*Download electoral data with mandatory and other optional parameters*). 

Entre los primeros se deben consignar `district` para el distrito; `category` para la catgoría; `round` para el turno e `year` para el año de la elección. Entre los segundos se puede agregar `level`para el nivel de agregación -`"provincia"`, `"departamento"`, `"circuito"`- y `long` para el formato de los datos alargados donde las listas no van cada una en una columna sino como valores de una variable `listas` (*Among the first, `district`; `category`;`round` and` year`  must be consigned. Between the seconds you can add `level` for the level of aggregation -`"province" `,`"department"`,`"circuit"`- and` long` for long formatted data where party lists do not go in columns but as values of a `lists` variable*).




- **`compute_competitiveness()`**: Calcula el nivel de competencia en una elección. Un parámetro `level` permite calcularlo para los distintos niveles de agregación presentes en la `data` (*Computes the level of competition in an election. A parameter `level` allows to calculate it for the different levels of aggregation present in the` data`*).

- **`compute_nep()`**: Calcula el  *Numero Efectivo de Partidos Politicos*. Es sensible al nivel de agregación de la `data` obtenida (*Computes the  'Effective Number of Political Parties'. It is sensitive to the level of aggregation of the obtained `data`*). 

- **`tabulate_results()`**: Genera una tabla con resultados agregados. Es posible obtener código \LaTeX de la tabla (*Generate a table with aggregated results. It is possible to get \LaTeX code from the table*).

- **`plot_results()`**: Grafica los resultados de una elección. Es sensible al nivel de agregación de la `data` obtenida (*Plots the results of an election. It is sensitive to the level of aggregation of the obtained `data`*).

### VIGNETTES

Se pueden consultar pequeños ejemplos de uso en las sección [ARTICULOS](https://electorarg.github.io/polAr/articles/) (*Small examples of use can be found in the ARTICLES section*).


### CREDITOS (*CREDITS*)

- Las liberías [`eph`](https://github.com/holatam/eph), [`electoral`](https://CRAN.R-project.org/package=electoral) y [`esaps`](https://nicolas-schmidt.github.io/esaps/index.html) fueron inspiración de este proyecto (*Libraries [`eph`](https://github.com/holatam/eph), [`electoral`](https://CRAN.R-project.org/package=electoral) and [`esaps`](https://nicolas-schmidt.github.io/esaps/index.html) were inspiration for this project.)*) 

- El acceso a los datos en bruto viene de las bases en archivos `.mdb` del [_Atlas Electoral de Andy Tow_](https://www.andytow.com/access/index.php?logout=true) (*Access to raw data comes from databases in `.mdb` files of [Andy Tow Electoral Atlas](https://www.andytow.com/access/index.php?logout=true)*).



### DATOS (*DATA*)

(**Trabajo en proceso - Work in progress**)

- La primera etapa de este proyecto consistió en un procesamiento de esos archivos para convertirlos a otros con formato `sqlite` para manipularlos más facilmente desde `R`(*The first stage of this project consisted in processing those files and convert them to others in `sqlite` format for easier manipulation with `R`*).

- Con esa información generamos cuadernos de `RMarkdown` para hacer las consultas de resultados para distintos años, cateogrías, turnos electorales y distrito. Pronto una descripción más detallada y documentación de este proceso (*With this information, we generate `RMarkdown` notebooks to query the results for different years, categories, electoral turns and district. Soon a more detailed description and documentation of this process*). 

### REFERENCIA (*RERENCE*)

```r
@Manual{,
    title = {polAr: Política Argentina usando R},
    author = {Juan Pablo {Ruiz Nicolini}},
    year = {2020},
    note = {R package version 0.0.0.9000},
    url = {https://github.com/electorArg/polAr},
  }


```
 
