library("lubridate")

old <- read.table("missing_packages.txt", header = FALSE, stringsAsFactors = FALSE)
new <- read.table("missing_packages_2020-03-17.txt", header = FALSE, stringsAsFactors = FALSE)
old <- old$V1
new <- new$V1

to_check <- setdiff(new, old)

already_checked <- setdiff(old, new)
cran_db <- tools::CRAN_package_db()
info_checked <- cran_db[na.omit(match(already_checked, cran_db$Package)), ]
date_checked <- year(info_checked$Published)

to_check <- c(to_check, already_checked[date_checked >= 2018])
write.table(to_check, file = "to_check.txt", row.names = FALSE, 
            col.names = FALSE)
