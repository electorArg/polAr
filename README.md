# PolA(R)

## POLítica ARgentina usando `R`

<img src="hex/hex-polAr.png" width="200">


La idea del paquete es birndar herramientas que faciliten el acceso a datos y flujo de trabajo para el análisis político - electoral, con ejempos aplicados de Argentina. 

---

**(Esta es una versión _beta_ del proyecto que dejamos abierto a comentarios y/o sugerencias)**. 

### INSTALACIÓN

_Versión en desarrollo_. 

```r

# install.packages('devtools') si no tiene instalado devtools

devtools::install_github("electorArg/polAr")

```

Sus principales funciones son:

- **`get_election_data()`**: Descarga bases de resultados electorales con parametros: `level`para el nivel de agregación (`"provincia"`, `"departamento"`, `"circuito"`) y `long` para el formato de los datos alargados (las listas no van cada una en una columna sino como valores de una variable `listas`). 

- **`show_available_elections`**: Diccionario de Elecciones disponibles. El parametro `viewer = TRUE` habilita una tabla en el _Viewer_ de `RStudio`.

- **`get_names()`**: Obtiene nombres de listas (funciona correctamente cuando los datos fueron obtenidos _LARGOS_: `election_get(data, ...,  long = T)`

- **`compute_nep()`**: Calcula el  Numero Efectivo de Partidos Politico. Es sensible al nivel de agregación de la `data` obtenida. 

- **`compute_competitiveness()`**: Calcula el nivel de competencia en una elección (0 , 1). Un parámetro `level` permite calcularlo para los distintos niveles de agregación presentes en la `data`.  



### CREDITOS

Parte de la inspiración viene de las liberías [`eph`](https://github.com/holatam/eph), [`electoral`](https://cran.r-project.org/web/packages/electoral/index.html) y [`esaps`](https://nicolas-schmidt.github.io/esaps/index.html)

El acceso a los datos en bruto viene de las bases en archivos `.mdb` del [_Atlas Electoral de Andy Tow_](https://www.andytow.com/access/index.php?logout=true). La primera etapa de este proyecto consistió en un procesamiento de esos archivos para convertirlos a otros con formato `sqlite` para manipularlos más facilmente desde `R`. Con esa información generamos cuadernos de `RMarkdown` para hacer las consultas de resultados para distintos años, cateogrías, turnos electorales y distrito (pronto una descripción más detallada y documentación de este proceso). Se espera tener un acceso a datos para todas las elecciones nacionales (diputados, senaodres y presidente) desde el año 2003 a 2019 al nivel disponible de desagregación mayor (mesas). 


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
 
