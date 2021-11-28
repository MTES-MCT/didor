.onLoad <- function(libname, pkgname) { # nolint # nocov start
  # make data set names global to avoid CHECK notes
  utils::globalVariables(".")
  utils::globalVariables("..1")
  utils::globalVariables("..2")

  invisible()
} # nocov end
