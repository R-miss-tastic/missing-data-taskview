library(tidyverse)
library(readr)

pkg_name_text <- read_lines(here::here("data/missing_packages.txt"))

miss_tv <- tibble(
  pkg_name = pkg_name_text,
  url = glue::glue("https://CRAN.R-project.org/package={pkg_name_text}"),
  updated_in_12m = "",
  vignette = "",
  comments = ""
)

miss_tv

# upload to google drive

library(googledrive)
write_csv(miss_tv, path = here::here("data/miss_tv.csv"))

googlesheets::gs_upload(file = here::here("data/miss_tv.csv"),
                        "missing-data-taskview")
