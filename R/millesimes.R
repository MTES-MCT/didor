#' Get millesimes informations
#'
#' @param data a tibble issued from `datafiles()`.
#'
#' @return a tibble of millesimes informations
#' @export
#'
#' @examples
#' datafiles() %>% dido_search("drom") %>% millesimes()
millesimes <- function(data) {
  if (missing(data)) {
    stop("`millesimes()` need an argument")
  }
  if (!is.data.frame(data)) {
    stop("data must be a dataframe", call. = FALSE)
  }
  if (!"rid" %in% names(data)) {
    stop("data must have a `rid` column", call. = FALSE)
  }
  dido_ml <- load_dido_metadata("dido_ml")

  select(data, "rid") %>%
    inner_join(dido_ml, by = c("rid")) %>%
    distinct()
}

#' Get data
#'
#' Get the data of the last millesime of all the datafiles found in data
#'
#' @param data a tibble issued from `datafiles() or a dataframe with two columns `rid` and `millesime`.
#' @param query a query to pass to the API to select columns and filter on
#'        values.
#' @param concat `TRUE`
#' @param col_types how to convert columns, the default is to use char for
#'        all columns `cols(.default = "c")`
#'
#' @return
#'
#' If concat is `TRUE` (default), return a tibble with all data concatenated
#'     in one tibble
#' If concat is `FALSE`, return a list of tibbles
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
#'   get_data(query = c(DEPARTEMENT_CODE= "eq:971"))
#' @importFrom magrittr %>%
#' @importFrom dplyr bind_rows select
#' @importFrom purrr pmap
#' @importFrom rlang .data
get_data <- function(data,
                     query = list(),
                     col_types = cols(.default = "c"),
                     concat = TRUE) {
  if (missing(data)) {
    stop("argument is mandatory.")
  }
  if (!is.data.frame(data)) {
    stop("argument must be a dataframe.", call. = FALSE)
  }
  if (!"rid" %in% names(data)) {
    stop("data must have an `rid` column.", call. = FALSE)
  }

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

  mill_keys <- select(mill, .data$rid, .data$millesime)
  list_df <- pmap(mill_keys, ~ get_csv(..1, ..2, query, col_types))

  if (!concat) {
    return(list_df)
  }
  dplyr::bind_rows(list_df)
}

#' Get columns count on millesimes
#'
#' This command return the list of columns founded in the input tibble with
#' the count. It allows you to verify millesimes are coherent
#'
#' @param data a datafiles tibble (as returned by the `datafiles()` function)
#'
#' @return a tibble with columns found in input datafiles and occurrence for
#'         each column
#' @export
#'
#' @examples
#' datafiles() %>% columns()
#' @importFrom magrittr %>%
#' @importFrom dplyr select inner_join slice_max
#' @importFrom tibble as_tibble
#' @importFrom rlang .data
columns <- function(data) {
  if (missing(data)) {
    stop("`millesimes()` need an argument")
  }
  if (!is.data.frame(data)) {
    stop("data must be a dataframe", call. = FALSE)
  }
  if (!"rid" %in% names(data)) {
    stop("data must have an `rid` column", call. = FALSE)
  }

  if (!"millesime" %in% names(data)) {
    mill <- last_millesime(data)
  } else {
    mill <- data
  }
  # cleaning
  mill_tmp <- distinct(mill, .data$rid, .data$millesime)
  if (nrow(mill_tmp %>% count(.data$rid) %>% filter(n > 1)) > 0) {
    stop("argument include more than one millesime per datafile")
  }
  message(paste0("nb of datafiles: ", nrow(mill)))

  mill %>%
    select(.data$columns) %>%
    unnest(.data$columns) %>%
    # as_tibble() %>%
    count(.data$name,
      .data$description,
      # TODO: uncomment when new API is released
      # .data$type,
      # .data$format,
      .data$unit,
      name = "nb of occurrences"
    )
}

#' Get last millesime
#'
#' @param data a datafiles tibble (as returned by the `datafiles()` function)
#'
#' @return a tibble with the last millesimes for all input datafiles
#' @export
#'
#' @examples
#' datafiles() %>% last_millesime()
#' @importFrom magrittr %>%
#' @importFrom dplyr select inner_join slice_max
#' @importFrom tibble as_tibble
#' @importFrom rlang .data
last_millesime <- function(data) {
  if (missing(data)) {
    stop("`last_millesime()` need an argument")
  }
  if (!is.data.frame(data)) {
    stop("data must be a dataframe", call. = FALSE)
  } else if (!"rid" %in% names(data)) {
    stop("data must have an `rid` column", call. = FALSE)
  }

  millesimes(data) %>%
    group_by(.data$rid) %>%
    slice_max(.data$millesime) %>%
    ungroup()
}
