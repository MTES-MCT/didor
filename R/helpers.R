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
#' @param file_name the file name used to cache download
#'
#' @return a didor_http_response with two fields:
#'   * parsed content with the `as` parameter
#'   * headers
#' @export
#'
#' @examples
#' result <- http_get(
#'   "https://data.statistiques.developpement-durable.gouv.fr/dido/api/v1/datasets?page=1&pageSize=10",
#'   as = "text"
#' )
#' @keywords internal
http_get <- function(url, as = NULL, file_name = NULL) {
  ua <- httr::user_agent(didor_user_agent)
  if (missing(file_name)) {
    response <- httr::GET(url, ua)
  } else {
    response <- httr::GET(url, ua, file_name, httr::progress())
  }

  if (httr::http_error(response)) {
    message <- c(paste0("Unable to get url ", httr::status_code(response)))

    error <- extract_http_error(response)
    if (!is.null(error)) message <- c(message, x = error)

    message <- c(message, i = paste0("url: ", response$url))
    rlang::abort(message = message)
  }
  headers <- httr::headers(response) %||% NULL
  if (!missing(file_name)) return(TRUE)
  structure(
    list(
      content = httr::content(response, as = as, encoding = "UTF-8"),
      headers = headers
    ),
    class = "didor_http_response"
  )
}

#' stringify_query
#'
#' @param data a query (named list)
#'
#' @return a string with only allowed char for file system name
#'
#' @noRd
stringify_query <- function(data) {
  if (length(data) == 0) return ("")

  text <- paste(lapply(names(data),
                       function(x) paste0(c(x, data[[x]]), collapse="=")),
                collapse=";")
  clean_text <- stringr::str_replace_all(text, regex("[^a-zA-Z0-9,;=_]"), "")
  paste0("-", clean_text)
}

#' @export
magrittr::`%>%`

