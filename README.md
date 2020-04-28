# PolA(R)

## POLítica ARgentina usando `R`

<img src="hex/hex-polAr.png" width="200">


La idea gdel paquete es birndar herramientas que faciliten el acceso a datos y flujo de trabajo para el análisis político - electoral, con ejempos aplicados de Argentina. 

---

Este es una versión _beta_ del proyecto que dejamos abierto a comentarios y/o sugerencias. 

**INSTALACIÓN**

Versión en desarrollo. 

```r

# install.packages('devtools') si no tiene instalado devtools

devtools::install_github("electorArg/polAr")

```

Sus principales funciones son:

- **`election_get()`**: Descarga bases de resultados electorales con parametros: `level`para el nivel de agregación (`"provincia"`, `"departamento"`, `"circuito"`) y `long` para el formato de los datos alargados (las listas no van cada una en una columna sino como valores de una variable `listas`). 

- **`election_get_raw()`**: Descarga de resultados electorales al nivel de MESA.

- **`election_collection()`**: Diccionario de Elecciones disponibles. El parametro `viewer = TRUE` habilita una tabla en el _Viewer_ de `RStudio`.

- **`get_listas()`**: Obtiene nombres de listas (funciona correctamente cuando los datos fueron obtenidos _LARGOS_: `election_get(data, long = T)`

- **`nep()`**: Calcula el  Numero Efectivo de Partidos Politico. Es sensible al nivel de agregación de la `data` obtenida. 

- **`competitive()`**: Calcula el nivel de competencia en una elección (0 , 1). Un parámetro `level` permite calcularlo para los distintos niveles de agregación presentes en la `data`.  



**CREDITOS**

Parte de la inspiración viene de la libería [`eph`](https://github.com/holatam/eph). 

El acceso a los datos en bruto viene de las bases en archivos `.mdb` del _Atlas Electoral de Andy Tow_. La primera etapa de este proyecto consistió en un procesamiento de esos archivos para convertirlos a otros con formato `sqlite` para maniuplarlos más facilmente desde `R`. Con esa información generamos cuadernos de `RMarkdown` para hacer las consultas de resultados para distintos años, cateogrías, turnos electorales y distrito (pronto una descripción más detallada y documentación de este proceso). 


**REFERENCIA**

```r
@Manual{,
    title = {polAr: Explora Datos Electorales de Argentina},
    author = {Juan Pablo {Ruiz Nicolini}},
    year = {2020},
    note = {R package version 0.0.0.9000},
    url = {https://github.com/electorArg/polAr},
  }


```
 
