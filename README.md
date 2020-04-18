# PolA(R)

## POLítica ARgentina usando `R`

<img src="hex/hex-polAr.png" width="200">


La idea general es armar un paquete de herramientas que faciliten el flujo de trabajo del análisis político - electoral, con ejempos aplicados a datos de política argentina,  inspirado en la libería [`eph`](https://github.com/holatam/eph). 

--- 

### DATOS DISPONIBLES 

#### RESULTADOS 

1. Tenemos procesadas la mayoría de las bases `sqlite` (originalmente en `mdb`, en la mayoría de los casos) con los resultados de elecciones nacionales para el periódo 2003 - 2019. 

2. Los datos incluyen tres categorias electorales: `Presidente`, `Diputados` y `Senadores`. 

3. Se incluyen elecciones primarias (`P.A.S.O.`) desde el año 2011, `balotaje` en 2015 y generales cada dos años para todo el período. 

4. Los resultados están disponibles al nivel de agregación más granular posible (`mesas`) en la organización electoral: 

**`mesa`** < `centro de votación` < `circuito electoral` < `sección electoral` < `provincia`


-> Generamos un archivo `csv` para cada  *categoria_anio_turno_provincia*. La idea es mantener consistencia en los nombres con una estructura como esa para poder hacer llamadas a las bases y aprovechar la información contenida en el nombre para trabajar con los datos. 

**A RESOLVER**: 

a. Dónde alojar los datos para que puedan ser llamados facilmente con una función de `polAr`? 

b. Cual es el formato más eficiente? 

#### GEO 

1. Tenemos los archivos con *polygons* para la creación de mapas a nivel `departamento` para todo el país. 

2. Tenemos grillas para `geofacet` de todas las provincias a nivel departamento (con nombre y codigo de departamento de INDRA asignado: `coddepto`)

---

**PENDIENTES**

(A) INTEGRAR TODA ESA INFORMACION EN UN REPOSITORIO AL QUE SE PUEDE ACCEDER 

(B) DETERMINAR DONDE ALOJAR LA DATA RAW PARA QUE LA LIBRERIA PUEDA DESCARGARLA

* En archivos `.csv` sin compresión, los resultados suman casi `0.5 GB`. 

* Hay un archivo por `elección_categoría_provincia` que suman más de 430 archivos

* Los nombres de los archivos tienen un patrón como el sigiente: `distrito_categoria_TurnoAnio.csv`

Ejemplos:  `caba_dip_gral2007` o `pba_sen_paso2011.csv`

(C) GENERAR LAS FUNCIONES PARA: 

a. llamar datos

b. procesarlos a los disitintos formatos esparados para los OUTPUTS ESPERADOS

c. generar tablas sumarias de resultados

d. generar graficos (mapas, hemiciclos legislativos, graficos de indicadores politicos, resultados)


---

### OUTPUTS ESPERADOS 

1. **RESULTADOS** (Dependencicas: `tidyverse`, `knitr`, `kableExtra`, `formattable` ???) 

tabulados y plots a disitintos niveles (unidad de análisis puede ser `nación` y las observaciones ser las `provincias` o se puede __escalar hacia abajo__ y que las observaciones sean los `departamentos` o `circuitos`)

2. **INDICADORES** (Dependencia: [`esaps`](https://github.com/Nicolas-Schmidt/esaps))

*(a)* **__Número Efectivo de Partidos__** (`NEP`)

*(b)* **__Volatilidad__**

*(c)* **__Fragmentación__**

*(d)* **__Nacionalización del Sistema de Partidos__**

*(e)* **__Desproporción__**

*(f)* **__Competitividad__** (ver `electoral` mencionado más abajo)


3. **GEO**  (Dependencias: `geofacet` y `sf`)

*(a)* Visualización de resultados en mapas (`SHP` con `sf`) (la disponibilidad completa de cartografía llega hasta el nivel `departamento`)

*(b)* `geofacet`: __grillas como si fueran mapas__ para representaciones de múltiples variables. 


4. **LEGISLATIVO** 

*(a)* Calculo de reparto de bacnas:  

(i) DIPUTADOS (proporcional por *D'Hondt* - ver [electoral](https://cran.r-project.org/web/packages/electoral/electoral.pdf)), 

(ii) SENADORES: *2x1* (primero / segundo)

---

Re pensar utildiad de esto. La composición del Congreso Nacional tiene renovaciones parciales. Habría que combinar bancas ganadas en elecciones sucesivas (dos años en caso de Diputados y tres en el de Senadores)

*(b)* [`ggparliament`](https://github.com/RobWHickman/ggparliament): visualización del reparto de bancas. 
---

5. **Bookdown** 

> Manual de análisis político desde R (~ Monogan) aplicado a ejemplos de Argentina utilizando `polAr`. 

> Ejemplos útiles: 

a. A. Vazquez Brust: [Ciencia de Datos para Gente Sociable](https://bitsandbricks.github.io/ciencia_de_datos_gente_sociable/)

b. Martin Montane: [Ciencia de Datos para Curiosos](https://bookdown.org/martinmontaneb/CienciaDeDatosParaCuriosos/)

c. Francisco Urdinez y Andrés Cruz Labrín (editores): [Análisis de Datos Políticos](https://arcruz0.github.io/libroadp/)
