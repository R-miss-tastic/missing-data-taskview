# download current gdrive

library(googledrive)

# googledrive::drive_download(file = "missing-data-taskview",
#                             path = "data/missing-data-taskview-njt.csv")


library(tidyverse)
miss_tv <- read_csv(here::here("data", "missing-data-taskview.csv"))

miss_tv %>% 
  filter(reviewer == "nick",
         decision == TRUE,
         updated_in_12m == TRUE,
         vignette == TRUE) %>%
  select(pkg_name,
         comments,
         everything()) %>%
  View()
