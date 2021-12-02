#' download attachment files
#'
#' @param url url of the attachment
#'
#' @param dest directory to save it, if `NULL` use current directory
#'
#' @noRd
#' @importFrom httr GET headers content
#' @keywords internal
download_attachment <- function(url, dest = NULL) {
  if (!(is.null(dest) || dir.exists(dest))) {
    stop(paste0("dest dir `", dest, "` doesn't exists"), call. = FALSE)
  }

  attachment <- httr::GET(url)
  if (httr::http_error(attachment)) {
    error <- extract_http_error(attachment)
    stop(error, call. = FALSE)
  }

  content_disposition <- httr::headers(attachment)$`content-disposition`
  file_name <- strsplit(content_disposition, '"')[[1]][2]
  if (!is.null(dest)) file_name <- paste0(dest, "/", file_name)

  tryCatch(
    {
      filehandle <- file(file_name, "wb")
      writeBin(httr::content(attachment), filehandle)
    },
    error = function(e) {
      stop(paste0("Unable to download file: ", e), call. = FALSE)
    },
    finally = {
      close(filehandle)
    }
  )
  message(paste0("file downloaded: ", file_name))
  invisible(TRUE)
}
