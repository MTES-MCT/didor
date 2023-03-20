#' Get metadata
#' @description Download information from api of from file passed as argument
#'              Load those data as tibble
#'
#'
#' @param url empty, url or filename. If no argument is passed, the default url
#'   is used. file must be compatible with the dido api format for
#'   https://data.statistiques.developpement-durable.gouv.fr/dido/api/v1/apidoc.html#/datasets/paginate_datasets
#'    datasets as described on
#'
#' @return nothing
#' @export
#'
#' @examples
#' \dontrun{
#' get_metadata("datasets.json")
#' }
#' @import tidyr
#' @import dplyr
#' @import tibble
#' @import stringr
get_metadata <- function(url = NULL) {
  if (is.null(url)) {
    url <- build_url("/datasets", query = c(page = 1, pageSize = "all"))
    response <- http_get(url, as = "text")
    data <- response$content
  } else {
    data <- readLines(url, encoding="UTF-8")
  }

  datasets <- jsonlite::fromJSON(data, flatten = TRUE)

  dido_ds <- datasets$data %>%
    as_tibble() %>%
    rename_at(
      vars(contains(".")),
      ~ str_replace(., "\\.", "_")
    ) %>%
    mutate(
      tags = map_chr(.data$tags, str_c, collapse = ","),
      spatial_zones = map_chr(.data$spatial_zones, str_c, collapse = ",")
    )

  dido_df <- dido_ds %>%
    select("id", "datafiles") %>%
    unnest("datafiles") %>%
    as_tibble() %>%
    rename_at(
      vars(contains(".")),
      ~ str_replace(., "\\.", "_")
    )

  dido_at <- dido_ds %>%
    select("id", "attachments") %>%
    unnest("attachments") %>%
    as_tibble()


  dido_ml <- dido_df %>%
    select("id", "rid", "millesimes") %>%
    unnest("millesimes") %>%
    mutate(geoFields = map_chr(.data$geoFields, str_c, collapse = ",")) %>%
    mutate(refs = map_chr(.data$refs, concat_dataframe_col, col = "name")) %>%
    as_tibble()

  dido_ds <- dido_ds %>% select(-c("datafiles", "attachments"))
  dido_df <- dido_df %>% select(-"millesimes")


  assign("dido_ml", dido_ml, envir = .dido_env)
  assign("dido_ds", dido_ds, envir = .dido_env)
  assign("dido_df", dido_df, envir = .dido_env)
  assign("dido_at", dido_at, envir = .dido_env)
}

#' concat_dataframe_col
#'
#' concat strings in col `col` of df `x` in one string
#'
#' @param data a dataframe
#' @param col the col name to use
#'
#' @return a string
#'
#' @noRd
concat_dataframe_col <- function(data, col) {
  if (is.null(data)) { return("") }

  str_c(unique(data[[col]]), collapse=", ")
}
