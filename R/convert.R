#' convert
#'
#' Try to convert columns according to types sended by the API.
#'
#' \strong{CAUTION} For private life reason, data returns by DiDo are secretize (the value is
#' replaced by the string "secret") so readr can't determine data type.
#'
#' All `secret` values will be transform to `NA`
#'
#' You can find column's type with `columns()`
#'
#' @param data a dataframe returned by `get_data()`
#'
#' @return a tibble with converted integer and number columns
#' @export
#'
#' @examples
#' datafiles() %>%
#'   dido_search("6c79805c-def9-4695-9d9f-7d86599c4d8a") %>%
#'   get_data() %>%
#'   convert()
#' @importFrom readr parse_number parse_integer
convert <- function(data) {
  if (missing(data)) {
    stop("argument data is mandatory.", call. = FALSE)
  }
  if (!is.data.frame(data)) {
    stop("data must be a dataframe.", call. = FALSE)
  }

  attributes <- get_attributes(data)

  for (col_name in names(data)) {
    type <- attributes(data[[col_name]])$type
    if ("converted" %in% names(attributes(data[[col_name]])) && attributes(data[[col_name]])$converted) {
      next
    }
    if (is.null(type)) {
      message(paste0("Unable to convert column ", col_name))
      next
    }
    if (type == "string") {
      next
    }

    if (type == "number") {
      data[[col_name]] <- readr::parse_double(data[[col_name]], na = c("", "NA", "secret"))
      attributes[[col_name]][["converted"]] <- TRUE
    } else if (type == "integer") {
      data[[col_name]] <- readr::parse_integer(data[[col_name]], na = c("", "NA", "secret"))
      attributes[[col_name]][["converted"]] <- TRUE
    }
  }
  set_attributes(data, attributes)
}
