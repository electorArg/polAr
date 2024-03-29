# ARCHIVADA - SIN MANTENIMIENTO
 
# `POL`ítica `A`rgentina usando `R` <a><img src="https://github.com/electorArg/polAr/blob/master/hex/hex-polAr.png?raw=true" width="200" align="right" /></a>


`{polAr}` brinda herramientas que facilitan el flujo de trabajo para el análisis político - electoral y el acceso a datos de Argentina desde `R` (*`polAr` provides tools that facilitate the workflow for political-electoral analysis and access to data from Argentina from `R`*). 

<!-- badges: start -->

[![Travis build status](https://travis-ci.org/electorArg/polAr.svg?branch=master)](https://travis-ci.org/electorArg/polAr)
[![github](https://img.shields.io/badge/devel%20version-0.2.1-red.svg)](https://github.com/electorArg/polAr)
[![DOI](https://zenodo.org/badge/256862665.svg)](https://zenodo.org/badge/latestdoi/256862665)


*[Archived](https://cloud.r-project.org/web/packages/polAr/index.html) from CRAN (2021-02-24)*

[![CRAN status](https://www.r-pkg.org/badges/version/polAr)](https://CRAN.R-project.org/package=polAr)
[![metacran downloads](https://cranlogs.r-pkg.org/badges/grand-total/polAr)](https://cran.r-project.org/package=polAr)

<!-- badges: end -->


---

### INSTALACIÓN (*Install*)


```r

# install.packages('devtools') si no tiene instalado devtools

devtools::install_github("electorArg/polAr")

```

Historial de cambios y funciones en el desarrollo del paquete pueden consultarse en detalle en [*changelog*](https://electorarg.github.io/polAr/news/index.html) (*Changes in package development can be found in detail in the [changelog](https://electorarg.github.io/polAr/news/index.html)*).

---

### VIGNETTES

Se pueden consultar pequeños ejemplos de uso en las sección [ARTICULOS](https://electorarg.github.io/polAr/articles/) (*Small examples of use can be found in the ARTICLES section*).

* [Data Access](https://electorarg.github.io/polAr/articles/data.html)

* [Computing](https://electorarg.github.io/polAr/articles/compute.html)

* [Displaying Results](https://electorarg.github.io/polAr/articles/results.html)


---

### CITA (*Cite*)

Para citar `{polAr}` en publicaciones usar (*To cite package ‘polAr’ in publications use*)

```r
  Juan Pablo Ruiz Nicolini (2020). polAr: Argentina
  Political Analysis. R package version 0.2.0.1 (dev)
  https://electorarg.github.io/polAr/



```


Una entrada BibTeX para LaTex (*A BibTeX entry for LaTeX users*)

```r
  @Manual{,
    title = {polAr: Argentina Political Analysis},
    author = {Juan Pablo {Ruiz Nicolini}},
    year = {2020},
    note = {R package version 0.2.0.1},
    url = {https://electorarg.github.io/polAr/},
  }



```
---

### CREDITOS (*Credits*)

- Las liberías [`eph`](https://github.com/holatam/eph), [`electoral`](https://CRAN.R-project.org/package=electoral) y [`esaps`](https://nicolas-schmidt.github.io/esaps/index.html) fueron inspiración y fuente de este proyecto (*Libraries [`eph`](https://github.com/holatam/eph), [`electoral`](https://CRAN.R-project.org/package=electoral) and [`esaps`](https://nicolas-schmidt.github.io/esaps/index.html) were inspiration for this project*). 

---

### TWITTER BOT

Junto a [Camila Higa](https://twitter.com/chig4_) trabajamos en un robot de twitter - [pol_ar_bot](https://twitter.com/pol_Ar_bot) - que se monta sobre `polAr` y responde consultas de usuaries sobre resultados de elecciones combinando las funciones `get_election_data()` y `plot_results()`. 

(*With [Camila Higa](https://twitter.com/chig4_) we work on a twitter bot - [pol_ar_bot](https://twitter.com/pol_Ar_bot) based on `polAr` develoment that answers election results queries from twitter users by combining `get_election_data()` and `plot_results()` functions*).

