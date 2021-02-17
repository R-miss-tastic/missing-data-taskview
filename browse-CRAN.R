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

write.table(unique(miss_pkgs$Package), file = "missing_packages_2021-02-17.txt",
            row.names = FALSE, col.names = FALSE, quote = FALSE)

table(miss_pkgs$word)

# imputation   imputations        impute       imputed       imputes      imputing   interpolate 
# 81             8            19            24             1             8             9 
# interpolated interpolating interpolation          miss       missing            na 
# 9             7            81             4           266            24

sessionInfo()
# R version 4.0.3 (2020-10-10)
# Platform: x86_64-pc-linux-gnu (64-bit)
# Running under: Ubuntu 20.04.2 LTS
# 
# Matrix products: default
# BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0
# LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0
# 
# locale:
#   [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=fr_FR.UTF-8       
# [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=fr_FR.UTF-8    LC_MESSAGES=en_US.UTF-8   
# [7] LC_PAPER=fr_FR.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
# [10] LC_TELEPHONE=C             LC_MEASUREMENT=fr_FR.UTF-8 LC_IDENTIFICATION=C       
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] XML_3.99-0.5    forcats_0.5.0   stringr_1.4.0   dplyr_1.0.1     purrr_0.3.4     readr_1.3.1    
# [7] tidyr_1.1.1     tibble_3.0.3    ggplot2_3.3.2   tidyverse_1.3.0 tidytext_0.3.0  lubridate_1.7.9
# 
# loaded via a namespace (and not attached):
#   [1] tidyselect_1.1.0  xfun_0.16         haven_2.3.1       lattice_0.20-41   colorspace_1.4-1 
# [6] vctrs_0.3.2       generics_0.0.2    htmltools_0.5.0   SnowballC_0.7.0   yaml_2.2.1       
# [11] blob_1.2.1        rlang_0.4.7       pillar_1.4.6      withr_2.2.0       glue_1.4.1       
# [16] DBI_1.1.0         dbplyr_1.4.4      modelr_0.1.8      readxl_1.3.1      lifecycle_0.2.0  
# [21] munsell_0.5.0     gtable_0.3.0      cellranger_1.1.0  rvest_0.3.6       evaluate_0.14    
# [26] knitr_1.29        fansi_0.4.1       broom_0.7.0       tokenizers_0.2.1  Rcpp_1.0.5       
# [31] backports_1.1.8   scales_1.1.1      jsonlite_1.7.0    fs_1.5.0          hms_0.5.3        
# [36] digest_0.6.25     stringi_1.4.6     grid_4.0.3        cli_2.0.2         tools_4.0.3      
# [41] magrittr_1.5      janeaustenr_0.1.5 crayon_1.3.4      pkgconfig_2.0.3   ellipsis_0.3.1   
# [46] Matrix_1.3-2      xml2_1.3.2        reprex_0.3.0      assertthat_0.2.1  rmarkdown_2.3    
# [51] httr_1.4.2        rstudioapi_0.11   R6_2.4.1          compiler_4.0.3  
