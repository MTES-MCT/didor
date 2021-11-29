#' Get data
#'
#' Get the data of the last millesime of all the datafiles found in data
#'
#' @param data a tibble issued from `datafiles() or a dataframe with two
#'        columns `rid` and `millesime`.
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
#'   get_data(query = c(DEPARTEMENT_CODE = "eq:971"))
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
  if (nrow(data) == 0) {
    if (concat) {
      return(NULL)
    } else {
      return(list())
    }
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
