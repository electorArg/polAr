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


- **`show_available_elections()`**: Diccionario de Elecciones disponibles. El parametro `viewer = TRUE` habilita una tabla en el _Viewer_ de `RStudio`.

- **`get_election_data()`**: Descarga bases de resultados electorales con parametros obligatorios y otros optativos. 

Entre los primeros se deben consignar `district` para el distrito; `category` para la catgoría; `round` para el turno e `year` para el año de la elección. Entre los segundos se puede agregar `level`para el nivel de agregación (`"provincia"`, `"departamento"`, `"circuito"`) y `long` para el formato de los datos alargados (las listas no van cada una en una columna sino como valores de una variable `listas`). 


- **`get_names()`**: Obtiene nombres de listas (funciona correctamente cuando los datos fueron obtenidos _LARGOS_: `election_get(data, ...,  long = T)`

- **`compute_competitiveness()`**: Calcula el nivel de competencia en una elección. Un parámetro `level` permite calcularlo para los distintos niveles de agregación presentes en la `data`.  

- **`compute_nep()`**: Calcula el  *Numero Efectivo de Partidos Politicos*. Es sensible al nivel de agregación de la `data` obtenida. 

- **`tabulate_results()`**: Genera una tabla con resultados agregados. Es posible obtener código \LaTeX de la tabla.

- **`plot_results()`**: GGrafica los resultados de una elección. Es sensible al nivel de agregación de la `data` obtenida.

### Vignettes

Se pueden consultar pequeños ejemplos de uso en las sección [ARTICULOS]()


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
 
