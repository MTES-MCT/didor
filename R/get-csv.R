#' @noRd
get_csv <- function(rid,
                    mil,
                    last_modified = NULL,
                    query = NULL,
                    col_types = cols(.default = "c"),
                    na = c("", "NA"),
                    cache = tempdir()) {
  path <- paste0("/datafiles/", rid, "/csv")
  default_query <- list(
    withColumnName = TRUE,
    withColumnDescription = FALSE,
    withColumnUnit = FALSE
  )

  file_name <- file.path(cache, paste0(rid, "-", mil, stringify_query(query), ".csv"))

  if (should_remove_cached_file(file_name, last_modified)) file.remove(file_name)

  if (!file.exists(file_name)) {
    cli_alert_info("downloading data and caching to : {file_name}")
    url <- build_url(path, default_query = default_query, query = query)
    response <- http_get(url, file_name = httr::write_disk(file_name))
  } else {
    cli_alert_info("reading data from cache : {file_name}")
  }

  cols <- get_columns_from_query(query)

  csv <- readr::read_delim(
    file_name,
    delim = ";",
    locale = locale(decimal_mark = "."),
    col_types = col_types,
    na = na,
    col_select = if (is.null(cols)) everything() else all_of(cols)
  )
  as_tibble(csv)
}

get_columns_from_query <- function(query) {
  if (is.null(query)) return(NULL)
  if (!'columns' %in% names(query)) return(NULL)

  str_split(query[['columns']], ",")[[1]]
}

# check a cached file, return TRUE if impossible to
# * test "freshness" (no last_modified)
# * last_modified is more recent than file's mtime
#
# FALSE otherwise
#
# last_modified is "2021-07-29T13:57:09.586Z"
#
should_remove_cached_file <- function(file_name, last_modified = NULL) {
  if (!file.exists(file_name)) return(FALSE)

  if (is.null(last_modified)) return(TRUE)

  file_mtime <- file.info(file_name)$mtime
  tmp_last_modified <- lubridate::ymd_hms(last_modified)
  if (tmp_last_modified > file_mtime) return(TRUE)

  FALSE
}
