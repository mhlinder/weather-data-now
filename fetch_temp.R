
## Fetch monthly temperature data for a given weather station

library(magrittr)
library(dplyr)

library(httr)
library(jsonlite)
library(urltools)

urlbase <- "http://data.rcc-acis.org/StnData?params=%s"

elem_template <- function(field) {
    list(name = field,
         interval = "mly",
         duration = "mly",
         reduce = "mean")
}
elems <- c("avgt", "hdd")

params <-
    list(sid   = "strc3",  ## Storrs, CT
         sdate = "2007-01-01",
         edate = as.character(Sys.Date()),
         elems = lapply(elems, elem_template))

query <-
    params %>%
    toJSON(auto_unbox = TRUE) %>%
    ## Encode JSON parameter list
    URLencode %>%
    sprintf(urlbase, .)

response <- GET(query) %>% content(as = "text") %>% fromJSON

df <-
    response$data %>%
    as.data.frame(stringsAsFactors = FALSE)
names(df) <- c("Date", elems)
