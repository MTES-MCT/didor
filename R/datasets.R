#' Get datasets informations
#'
#' @description
#'
#' Load datasets information in a tibble if needed and return it
#'
#' @param data a datafiles tibble (as returned by the `datafiles()` function)
#'        or NULL (default)
#'
#' @return a tibble of datasets information
#' @export
#'
#' @examples
#' datasets()
datasets <- function(data = NULL) {
  dido_ds <- load_dido_metadata("dido_ds")
  if (is.null(data)) {
    return(dido_ds)
  }

  if (!is.data.frame(data)) {
    stop("data must be a dataframe", call. = FALSE)
  } else if (!"id" %in% names(data)) {
    stop("data must have an `id` column", call. = FALSE)
  }

  select(data, "id") %>%
    inner_join(dido_ds, by = c("id"), multiple = "all") %>%
    distinct()
}
