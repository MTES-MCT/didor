#' Get datafiles informations
#'
#' return information on all datafiles or on
#' can use a `datasets()` command as entry
#'
#' @param data tibble of datasets as given by `datasets()` or `NULL` (default)
#'
#' @return a tibble of datafiles informations
#' @export
#'
#' @examples
#' dfs <- datafiles()
datafiles <- function(data = NULL) {
  dido_df <- load_dido_metadata("dido_df")

  if (is.null(data)) {
    return(dido_df)
  }

  if (!is.data.frame(data)) {
    stop("data must be a dataframe", call. = FALSE)
  } else if (!"id" %in% names(data)) {
    stop("data must have an `id` column", call. = FALSE)
  }

  select(data, id) %>%
    inner_join(dido_df, by = c("id"), multiple = "all")
}
