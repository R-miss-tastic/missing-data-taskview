Missing Data Task View
================
Julie Josse, Nicholas Tierney and Nathalie Vialaneix (r-miss-tastic
team)
09 mars, 2020

<!-- README.md is generated from README.Rmd. Please edit that file -->

The Missing Data task view source is in the file `MissingData.ctv` that
can be transformed into an HTML file using the **R** package
[ctv](https://CRAN.R-project.org/package=ctv)

``` r
library(ctv)
setwd(paste(getwd(), "source", sep = "/"))
source_ctv <- read.ctv("MissingData.ctv")
ctv2html(source_ctv, css = "../CRAN_web_css")
```

In addition, CTV can be checked before submission to CRAN with:

``` r
check_ctv_packages("source/MissingData.ctv")
#> $`Packages in <info> but not in <packagelist>`
#> character(0)
#> 
#> $`Packages in <packagelist> but not in <info>`
#> character(0)
#> 
#> $`Packages in <packagelist> but not in repos`
#> character(0)
```
