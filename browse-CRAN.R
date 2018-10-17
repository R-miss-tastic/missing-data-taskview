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
#> [1] 322

write.table(unique(miss_pkgs$Package), file = "missing_packages.txt",
            row.names = FALSE, col.names = FALSE, quote = FALSE)

table(miss_pkgs$word)

# imputation   imputations        impute       imputed       imputes 
# 109            12            25            19             4 
# imputing   interpolate  interpolated interpolating interpolation 
# 11             9             5             4            56 
# miss       missing            na 
# 4           254            15

sessionInfo()
# R version 3.4.4 (2018-03-15)
# Platform: x86_64-pc-linux-gnu (64-bit)
# Running under: Ubuntu 16.04.5 LTS
# 
# Matrix products: default
# BLAS: /usr/lib/libblas/libblas.so.3.6.0
# LAPACK: /usr/lib/lapack/liblapack.so.3.6.0
# 
# locale:
#   [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
# [3] LC_TIME=fr_FR.UTF-8        LC_COLLATE=en_US.UTF-8    
# [5] LC_MONETARY=fr_FR.UTF-8    LC_MESSAGES=en_US.UTF-8   
# [7] LC_PAPER=fr_FR.UTF-8       LC_NAME=C                 
# [9] LC_ADDRESS=C               LC_TELEPHONE=C            
# [11] LC_MEASUREMENT=fr_FR.UTF-8 LC_IDENTIFICATION=C       
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] bindrcpp_0.2.2  XML_3.98-1.15   forcats_0.3.0   stringr_1.3.0  
# [5] dplyr_0.7.4     purrr_0.2.4     readr_1.1.1     tidyr_0.8.0    
# [9] tibble_1.4.2    ggplot2_2.2.1   tidyverse_1.2.1 tidytext_0.1.9 
# 
# loaded via a namespace (and not attached):
#   [1] Rcpp_0.12.16      cellranger_1.1.0  pillar_1.2.1      compiler_3.4.4   
# [5] plyr_1.8.4        bindr_0.1.1       tokenizers_0.2.1  tools_3.4.4      
# [9] jsonlite_1.5      lubridate_1.7.4   nlme_3.1-131.1    gtable_0.1.2     
# [13] lattice_0.20-35   pkgconfig_2.0.1   rlang_0.2.0       Matrix_1.2-14    
# [17] cli_1.0.0         rstudioapi_0.7    yaml_2.1.18       haven_1.1.1      
# [21] xml2_1.2.0        janeaustenr_0.1.5 httr_1.3.1        hms_0.4.2        
# [25] grid_3.4.4        glue_1.2.0        R6_2.2.2          readxl_1.0.0     
# [29] modelr_0.1.2      magrittr_1.5      backports_1.1.2   scales_0.4.1     
# [33] SnowballC_0.5.1   rvest_0.3.2       assertthat_0.2.0  colorspace_1.2-4 
# [37] utf8_1.1.3        stringi_1.1.7     lazyeval_0.2.1    munsell_0.4.2    
# [41] broom_0.5.0       crayon_1.3.4