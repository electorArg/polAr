# polAr 0.1.3.2

**Jul 5, 2020: dev version**

* Added two new functions in previous workflow:

1. `get_multiple_elections()`  helps downloading multiple elections data with only one call. 

2. `compute_seats()` assigns the expected number of seats that a party should get bases on it´s votes. 

* Added a new workflow around presidential speeches with three functions:

1. exploring data with `show_available_speech()`

2. downloading data with `get_speech()`

3. visualize data with `plot_speech()`

# polAr 0.1.3.1

**May 26, 2020: dev version**

* Add first version of `map_results()` function to visualize election data in geographical format with polygons as geometry.

* Minor fix in `geofacet` plots (`aspect.ratio` inside `ggplot2::theme()`).

* Simplify visualization workflow adding `get_names()` helper function explicitly inside `plot_results()`, `map_results()` and `tabulate_results()` functions.

# polAr 0.1.3 

**CRAN release**

# polAr 0.1.2

**May 9, 2020:  resubmitting whith reviewer changes requests**

* Add "cph" to Authors\@R in DESCRIPTION

* Fix `tabulate_results()` output removing it´s printing to console step and keeping it as an object

* Added minimal examples for functions and improved  their documentation in Rd files
  
# polAr 0.1.1

**May 6, 2020: resubmitting with fix in minor bugs**

# polAr 0.1.0

**May 5, 2020:  first submission to CRAN**
