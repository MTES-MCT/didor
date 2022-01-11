#' download attachments
#'
#' @param data tibble of datasets as given by `attachments()`.
#'        Must contains an `id` column
#' @param dest a directory to write files
#'
#' @export
#'
#' @examples
#' datasets() %>%
#'   dido_search("drom") %>%
#'   attachments() %>%
#'   get_attachments(dest = tempdir())
#' @importFrom purrr pmap
get_attachments <- function(data, dest = NULL) {
  if (!is.data.frame(data)) {
    stop("data must be a dataframe", call. = FALSE)
  } else if (!"url" %in% names(data)) {
    stop("data must have an `url` column", call. = FALSE)
  }
  select(data, url) %>%
    distinct(url) %>%
    pmap(~ download_attachment(..1, dest = dest))
  invisible(data)
}
