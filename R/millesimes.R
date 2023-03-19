#' Get millesimes informations
#'
#' @param data a tibble issued from `datafiles()`.
#'
#' @return a tibble of millesimes informations
#' @export
#'
#' @examples
#' datafiles() %>%
#'   dido_search("drom") %>%
#'   millesimes()
millesimes <- function(data) {
  if (missing(data)) {
    stop("`millesimes()` need an argument")
  }
  if (!is.data.frame(data)) {
    stop("data must be a dataframe", call. = FALSE)
  }
  if (!"rid" %in% names(data)) {
    stop("data must have a `rid` column", call. = FALSE)
  }
  dido_ml <- load_dido_metadata("dido_ml")

  join_by <- c("rid")
  if ("millesime" %in% names(data)) {
    join_by <- append(join_by, "millesime")
  }

  select(data, unlist(join_by)) %>%
    inner_join(dido_ml, by = join_by, multiple = "all") %>%
    distinct()
}

#' Get columns count on millesimes
#'
#' This command return the list of columns founded in the input tibble with
#' the count. It allows you to verify millesimes are coherent
#'
#' @param data a datafiles tibble (as returned by the `datafiles()` function)
#' @param quiet logical; suppress message. Default to FALSE
#'
#' @return a tibble with columns found in input datafiles and occurrence for
#'         each column
#' @export
#'
#' @examples
#' datafiles() %>% columns()
columns <- function(data, quiet = FALSE) {
  if (missing(data)) {
    stop("`millesimes()` need an argument")
  }
  if (!is.data.frame(data)) {
    stop("data must be a dataframe", call. = FALSE)
  }
  if (!"rid" %in% names(data)) {
    stop("data must have an `rid` column", call. = FALSE)
  }

  if (!"millesime" %in% names(data)) {
    mill <- last_millesime(data)
  } else {
    mill <- data
  }
  # cleaning
  mill_tmp <- distinct(mill, .data$rid, .data$millesime)
  if (nrow(mill_tmp %>% count(.data$rid) %>% filter(n > 1)) > 0) {
    stop("argument include more than one millesime per datafile")
  }
  if (!quiet) {
    message(paste0("nb of datafiles: ", nrow(mill)))
  }

  columns <- mill %>%
    select("columns") %>%
    unnest("columns")

  if (!"format" %in% names(columns)) {
    columns <- mutate(columns, format = NA_character_) %>%
      relocate(format, .after = "type")
  }

  columns %>%
    count(.data$name,
      .data$description,
      .data$type,
      .data$format,
      .data$unit,
      name = "nb of occurrences"
    )
}

#' Get last millesime
#'
#' @param data a datafiles tibble (as returned by the `datafiles()` function)
#'
#' @return a tibble with the last millesimes for all input datafiles
#' @export
#'
#' @examples
#' datafiles() %>% last_millesime()
last_millesime <- function(data) {
  if (missing(data)) {
    stop("`last_millesime()` need an argument")
  }
  if (!is.data.frame(data)) {
    stop("data must be a dataframe", call. = FALSE)
  } else if (!"rid" %in% names(data)) {
    stop("data must have an `rid` column", call. = FALSE)
  }

  millesimes(data) %>%
    group_by(.data$rid) %>%
    slice_max(.data$millesime) %>%
    ungroup()
}
