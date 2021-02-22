## Resubmission 

Added httr::stop_for_status() to FAIL SAFELY when internet resources are not available. Checking calls to github in the R directory.  

0 errors √ | 1 warning x | 1 note x


## Resubmission polAr

0 errors √ | 1 warning x | 2 notes x

Travis: passing https://travis-ci.org/github/electorArg/polAr

winbuilder: checked and built


## Resubmission polAr
This is a resubmission -version 0.1.3. As asked by reviewer, in this version I: 
* Update description in DESCRIPTION file to an English version. 
* Add translated infromation in README file. 

## Resubmission polAr
This is a resubmission -version 0.1.2. As asked by reviewer, in this version I: 

* add [cph] to the Authors@R field in DESCRIPTION.
* add \value and examples to .Rd files by editing .R files headers with @return and @examples
* removed de cat() command from tabulate_results.R My intention was to make it handy to get LaTeX code from the console when writing LaTeX = TRUE in the function parameter. But I fix as suggested by reviewer and show how to use it using cat() in the minimal example. 
* improved the whole documentation


## Resubmission
This is a resubmission. In this version I have:

* in this version I fixed the only comment received regarding a missing URL in the file README.md by reviewer
* fixed minor bugs in functions when dealing with some particular data


## Test environments
* local OS X install, R 3.6.1
* ubuntu 14.04 (on travis-ci), R 3.6.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
