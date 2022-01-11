#' @noRd
#' @importFrom readr read_delim locale cols

get_csv <- function(rid,
                    mil,
                    query = NULL,
                    col_types = cols(.default = "c"),
                    na = c("", "NA")) {
  path <- paste0("/datafiles/", rid, "/csv")
  default_query <- list(
    withColumnName = TRUE,
    withColumnDescription = FALSE,
    withColumnUnit = FALSE
  )

  url <- build_url(path, default_query = default_query, query = query)
  as_tibble(readr::read_delim(url,
                              delim = ";",
                              locale = locale(decimal_mark = "."),
                              col_types = col_types, na = na
  ))
}