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
    select(.data$id, .data$datafiles) %>%
    unnest(.data$datafiles) %>%
    as_tibble() %>%
    rename_at(
      vars(contains(".")),
      ~ str_replace(., "\\.", "_")
    )

  dido_at <- dido_ds %>%
    select(.data$id, .data$attachments) %>%
    unnest(.data$attachments) %>%
    as_tibble()

  dido_ml <- dido_df %>%
    select(.data$id, .data$rid, .data$millesimes) %>%
    unnest(.data$millesimes) %>%
    mutate(geoFields = map_chr(.data$geoFields, str_c, collapse = ",")) %>%
    mutate(refs = map_chr(.data$refs, str_c, collapse = ",")) %>%
    as_tibble()

  dido_ds <- dido_ds %>% select(-c(.data$datafiles, .data$attachments))
  dido_df <- dido_df %>% select(-.data$millesimes)


  assign("dido_ml", dido_ml, envir = .dido_env)
  assign("dido_ds", dido_ds, envir = .dido_env)
  assign("dido_df", dido_df, envir = .dido_env)
  assign("dido_at", dido_at, envir = .dido_env)
}
