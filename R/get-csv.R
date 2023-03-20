#' @noRd
get_csv <- function(rid,
                    mil,
                    query = NULL,
                    col_types = cols(.default = "c"),
                    na = c("", "NA"),
                    directory = tempdir()) {
  path <- paste0("/datafiles/", rid, "/csv")
  default_query <- list(
    withColumnName = TRUE,
    withColumnDescription = FALSE,
    withColumnUnit = FALSE
  )

  file_name <- file.path(directory, paste0(rid, "-", mil, stringify_query(query), ".csv"))

  url <- build_url(path, default_query = default_query, query = query)
  response <- http_get(url, file_name = httr::write_disk(file_name, overwrite = TRUE))
  csv <- readr::read_delim(
    file_name,
    delim = ";",
    locale = locale(decimal_mark = "."),
    col_types = col_types,
    na = na
  )
  as_tibble(csv)
}
