#' Get attachments informations
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
#' \donttest{
#' dfs <- datafiles()
#' }
attachments <- function(data = NULL) {
  dido_at <- load_dido_metadata("dido_at")
  if (is.null(data)) {
    return(dido_at)
  }

  if (!is.data.frame(data)) {
    stop("data must be a dataframe", call. = FALSE)
  } else if (!"id" %in% names(data)) {
    stop("data must have an `id` column", call. = FALSE)
  }

  select(data, id) %>%
    inner_join(dido_at, by = c("id"), multiple = "all")
}
