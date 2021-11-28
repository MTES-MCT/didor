#' Return row matching pattern
#'
#' @param data Tibble of datasets or datafiles as returned by datasets()
#'        and datafiles()
#' @param pattern string used to filter the dataset and idbank list
#'
#' @return the datafiles or datasets table filtered with the pattern
#' @export
#'
#' @examples
#' dido_search(datasets(), "drom")
#' @importFrom dplyr filter_all any_vars
dido_search <- function(data, pattern) {
  filter(data, if_any(everything(), ~ grepl(pattern, ., ignore.case = TRUE)))
}
