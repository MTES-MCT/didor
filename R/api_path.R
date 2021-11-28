default_api_base_path <-
  "https://data.statistiques.developpement-durable.gouv.fr/dido/api/v1"

#' Get API base path
#'
#' @description
#'
#' Get the API base path. Can be configured with `set_api_base_path` and with
#'    `DIDOLITE_API_BASE_PATH` env var. Order is :
#' 1. if set_api_base_path has been used
#' 2. `DIDOLITE_API_BASE_PATH`
#' 3. the default default_api_base_path
#'
#' @return the api base path
#' @export
#'
#' @examples
#' get_api_base_path()
get_api_base_path <- function() {
  if (exists("api_base_path", envir = .dido_env)) {
    return(get("api_base_path", envir = .dido_env))
  }

  base_path <- Sys.getenv("DIDOLITE_API_BASE_PATH")
  if (base_path != "") {
    return(base_path)
  }

  default_api_base_path
}

#' Set API base path
#'
#' @description
#'
#' set a new API base path to use
#'
#' @param path the path to set or NULL (default value).
#'   if set to non `NULL`, set the path
#'   if `NULL`
#'
#' @return nothing
#' @export
#'
#' @examples
#' # to set some new path
#' set_api_base_path("http://localhost/api/")
set_api_base_path <- function(path = NULL) {
  if (is.null(path) && exists("api_base_path", envir = .dido_env)) {
    rm(list = "api_base_path", envir = .dido_env)
  }

  if (!is.null(path)) {
    assign("api_base_path", path, envir = .dido_env)
  }
}
