#' @name get_data
#'
#' @title Get data
#'
#' @description Get the data of the last millesime of all the datafiles found in data. All columns are returned as `chr` (see below). \cr
#'
#' For private life reason, data returned by DiDo can be secretize (the value is
#' replaced by the string "secret") so readr can't determine data type. You can
#' use `convert()` to convert number and integer.
#'
#' get_data cache data before loading it. By default it saves the files
#' in `tempdir()`. If you downloaded the same data again, il will first try to
#' find it in the `cache` argument. If you want to cache data between
#' session, don't keep the default but use your own directory.
#'
#'
#' @param data a tibble issued from `datafiles() or a dataframe with two columns
#'   `rid` and `millesime`.
#' @param query a query to pass to the API to select columns and filter on
#'   values.
#' @param concat `TRUE` if `TRUE`, returns a tibble with all data concatenated in one tibble, else returns a list of tibbles.
#' @param col_types how to convert columns, the default is to use char for all
#'   columns `cols(.default = "c")`
#' @param cache the directory to cache/save downloaded files. Default is `tempdir()`
#'
#' @return
#'
#' If concat is `TRUE` (default), return a tibble with all data concatenated in
#' one tibble.
#' If concat is `FALSE`, return a list of tibbles.
#'
#' `get_data()` returns only chr columns. Use `convert` to convert columns to good types.
#'
#' @details
#'
#' For caching, `get_data()` will use a reproductible name compose of the
#' datafile identifier (rid) and the stringification of the query passed to
#' `get_data()` of a query is passed. It will verify compare cached data with
#' API information before using it.
#'
#' @export
#'
#' @examples
#' # get all columns
#' datafiles() %>%
#'   dido_search("drom") %>%
#'   get_data()
#' # get only DEPARTEMENT_CODE and ESSENCE_M3 columns
#' datafiles() %>%
#'   dido_search("drom") %>%
#'   get_data(query = c(columns = "DEPARTEMENT_CODE,ESSENCE_M3"))
#' # get only rows where `DEPARTEMENT_CODE == 971
#' datafiles() %>%
#'   dido_search("drom") %>%
#'   get_data(query = c(DEPARTEMENT_CODE = "eq:971"))
#' datafiles() %>%
#'   dido_search("drom") %>%
#'   get_data(query = c(DEPARTEMENT_CODE = "eq:971"), cache = tempdir())
get_data <- function(data,
                     query = list(),
                     col_types = cols(.default = "c"),
                     concat = TRUE,
                     cache = tempdir()) {
  if (missing(data)) {
    stop("argument is mandatory.")
  }
  if (!is.data.frame(data)) {
    stop("argument must be a dataframe.", call. = FALSE)
  }
  if (!"rid" %in% names(data)) {
    stop("data must have an `rid` column.", call. = FALSE)
  }
  if (nrow(data) == 0) {
    if (concat) {
      return(NULL)
    } else {
      return(list())
    }
  }

  dir.create(cache, recursive = TRUE, showWarnings = FALSE)

  if (!"millesime" %in% names(data)) {
    mill <- last_millesime(data)
  } else {
    mill <- data
  }
  # cleaning
  mill <- distinct(mill, .data$rid, .data$millesime)
  if (nrow(mill %>% count(.data$rid) %>% filter(n > 1)) > 0) {
    stop("argument include more than one millesime per datafile")
  }

  millesime_keys <- mill %>% left_join(datafiles(), by = "rid") %>% select("rid", "millesime", "last_modified")
  list_df <- pmap(millesime_keys, ~ get_csv(..1, ..2, ..3, query, col_types, cache = cache))

  columns <- millesimes(millesime_keys) %>%
    columns(quiet = TRUE)
  attributes <- build_attributes(columns)

  if (!concat) {
    return(purrr::map(list_df, ~ set_attributes(., attributes)))
  }
  set_attributes(dplyr::bind_rows(list_df), attributes)
}
