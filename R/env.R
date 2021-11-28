.dido_env <- new.env()

#' @noRd
load_dido_metadata <- function(var) {
  if (!exists(var, envir = .dido_env)) {
    get_metadata()
  }
  get(var, envir = .dido_env)
}
