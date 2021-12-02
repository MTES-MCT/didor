#' set_attributes
#'
#' add information to downloaded dataframe as attributes
#' * description
#' * unit
#' * type : concatenation of type and format as returned by API
#'
#' @param data a dataframe
#' @param metadata named list as returned by `build_attributes()`
#'
#' @return a dataframe with attributes on columns
#'
#' @keywords internal
set_attributes <- function(data, metadata) {
  if (missing(data)) {
    stop("argument data is mandatory.", call. = FALSE)
  }
  if (!is.data.frame(data)) {
    stop("data must be a dataframe.", call. = FALSE)
  }

  for (col_name in names(data)) {
    for (metadata_name in c("name", "description", "unit", "type", "converted")) {
      attr(data[[col_name]], metadata_name) <- metadata[[col_name]][[metadata_name]]
    }
  }
  return(data)
}

#' build_attributes
#'
#' return attributes to attach to downloaded dataframe
#'
#' @param columns; as returned by `columns()`
#'
#' @keywords internal
build_attributes <- function(columns) {
  if (missing(columns)) {
    stop("columns is mandatory.", call. = FALSE)
  }
  if (!is.data.frame(columns)) {
    stop("columns must be a dataframe.", call. = FALSE)
  }
  columns <- replace_na(columns, list(format = ""))
  metadata <- split(columns, columns$name)

  for (col_name in names(metadata)) {
    metadata[[col_name]][["name"]] <- col_name
    metadata[[col_name]][["converted"]] <- FALSE
    metadata[[col_name]][["type"]] <- paste0(metadata[[col_name]][["type"]], metadata[[col_name]][["format"]])
  }
  return(metadata)
}

#' get_attributes
#'
#' used internally to reapply attributes on data
#'
#' @param data a data frame as returned by get_data
#'
#' @return a named list of named list of attributes by column names
#' @export
#'
#' @keywords internal
get_attributes <- function(data) {
  attributes <- list()
  for (col_name in names(data)) {
    attributes[[col_name]] <- attributes(data[[col_name]])
  }
  return(attributes)
}
