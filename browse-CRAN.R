# packages
library(tidytext)
library(tidyverse)
library(XML)

# keywords for missing data
mda_words <- c("miss",
               "missing",
               "matrix completion",
               "interpolate",
               "interpolated",
               "interpolation",
               "interpolating",
               "matrix complete",
               "matrix completing",
               "NA",
               "na",
               "impute",
               "imputed",
               "imputes",
               "imputation",
               "imputations",
               "imputing")

# extract already listed packages
cur_page <- htmlTreeParse("source/MissingData.ctv", useInternalNodes = TRUE)
listed_packages <- unique(xpathSApply(cur_page, "//pkg", xmlValue))

# browse CRAN
cran_db <- tools::CRAN_package_db()

cran_tbl <- tibble::as_tibble(cran_db[-65])

cran_tbl_short <- cran_tbl %>% select(Package, Description)

tidy_desc <- cran_tbl_short %>% unnest_tokens(word, Description)

data("stop_words")

cleaned_desc <- tidy_desc %>% anti_join(stop_words)

miss_pkgs <- cleaned_desc %>% 
  group_by(Package) %>%
  filter(word %in% mda_words) %>%
  filter(!(Package %in% listed_packages)) %>%
  ungroup()


n_distinct(miss_pkgs$Package)
#> [1] 328

write.table(unique(miss_pkgs$Package), file = "missing_packages_2020-03-17.txt",
            row.names = FALSE, col.names = FALSE, quote = FALSE)

table(miss_pkgs$word)

# imputation   imputations        impute       imputed       imputes      imputing   interpolate  interpolated 
# 73            11            17            30             1             9             8             8 
# interpolating interpolation          miss       missing            na 
# 5            65             4           252            20

sessionInfo()
# R version 3.6.3 (2020-02-29)
# Platform: x86_64-pc-linux-gnu (64-bit)
# Running under: Ubuntu 18.04.4 LTS
# 
# Matrix products: default
# BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.7.1
# LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.7.1
# 
# locale:
#   [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=fr_FR.UTF-8        LC_COLLATE=en_US.UTF-8    
# [5] LC_MONETARY=fr_FR.UTF-8    LC_MESSAGES=en_US.UTF-8    LC_PAPER=fr_FR.UTF-8       LC_NAME=C                 
# [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=fr_FR.UTF-8 LC_IDENTIFICATION=C       
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] tidytext_0.2.3  XML_3.98-1.20   forcats_0.4.0   stringr_1.4.0   dplyr_0.8.3     purrr_0.3.3     readr_1.3.1    
# [8] tidyr_1.0.2     tibble_2.1.3    ggplot2_3.3.0   tidyverse_1.3.0
# 
# loaded via a namespace (and not attached):
#   [1] tidyselect_0.2.5  xfun_0.8          haven_2.2.0       lattice_0.20-40   colorspace_1.4-1  vctrs_0.2.3      
# [7] generics_0.0.2    SnowballC_0.6.0   htmltools_0.3.6   yaml_2.2.0        rlang_0.4.5       pillar_1.4.2     
# [13] glue_1.3.1        withr_2.1.2       DBI_1.0.0         dbplyr_1.4.2      modelr_0.1.6      readxl_1.3.1     
# [19] lifecycle_0.1.0   munsell_0.5.0     gtable_0.3.0      cellranger_1.1.0  rvest_0.3.5       evaluate_0.14    
# [25] knitr_1.23        tokenizers_0.2.1  broom_0.5.2       Rcpp_1.0.1        scales_1.0.0      backports_1.1.4  
# [31] jsonlite_1.6      fs_1.3.1          hms_0.5.3         digest_0.6.20     stringi_1.4.3     grid_3.6.3       
# [37] cli_1.1.0         tools_3.6.3       magrittr_1.5      janeaustenr_0.1.5 crayon_1.3.4      pkgconfig_2.0.2  
# [43] Matrix_1.2-18     xml2_1.2.2        reprex_0.3.0      lubridate_1.7.4   assertthat_0.2.1  rmarkdown_1.14   
# [49] httr_1.4.1        rstudioapi_0.10   R6_2.4.0          nlme_3.1-144      compiler_3.6.3  
