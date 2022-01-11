didor_user_agent <- "https://github.com/MTES-MCT/didor"

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

extract_http_error <- function(resp) {
  if (grepl("json", httr::headers(resp)$`Content-Type`)) {
    json <- jsonlite::parse_json(resp)
    paste0(json$message, ": ", str_c(json$errors, ", "))
  } else {
    NULL
  }
}

#' Run HTTP GET request
#'
#' @param url the url
#' @param as text/NULL, return as text or as is
#'
#' @return a didor_http_response with two fields:
#'   * parsed content with the `as` parameter
#'   * headers
#' @export
#'
#' @examples
#' http_get(
#'   "https://data.statistiques.developpement-durable.gouv.fr/dido/api/v1/datasets?page=1&pageSize=10",
#'   as = "text"
#' )
#' @keywords internal
http_get <- function(url, as = NULL) {
  ua <- httr::user_agent(didor_user_agent)
  response <- httr::GET(url, ua)

  if (httr::http_error(response)) {
    message <- c(paste0("Unable to get url ", httr::status_code(response)))

    error <- extract_http_error(response)
    if (!is.null(error)) message <- c(message, x = error)

    message <- c(message, i = paste0("url: ", response$url))
    rlang::abort(message = message)
  }
  headers <- httr::headers(response) %||% NULL
  structure(
    list(
      content = httr::content(response, as = as),
      headers = headers
    ),
    class = "didor_http_response"
  )
}

#' @export
magrittr::`%>%`

