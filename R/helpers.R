#' Build url
#'
#' build url from all parameters
#'
#' @param path the api route
#' @param default_query the default parameters for the query as a vector
#' @param query the users parameters for the query as a vector
#'
#' @return the complete url to call
#' @export
#'
#' @examples
#' build_url("/datasets", query = c(page = 1, pageSize = 1))
#' build_url("/datasets",
#'   default_query = c(default = "default"),
#'   query = c(page = 1, pageSize = 1)
#' )
#' @keywords internal
build_url <- function(path, default_query = list(), query = list()) {
  for (key in names(query)) {
    default_query[key] <- query[key]
  }
  args <- list()
  for (key in names(default_query)) {
    args <- c(args, paste0(key, "=", default_query[key]))
  }

  url <- paste0(get_api_base_path(), path)
  if (length(args) > 0) url <- paste0(url, "?", paste(args, collapse = "&"))
  url
}

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`
