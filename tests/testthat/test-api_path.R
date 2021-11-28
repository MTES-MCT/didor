test_that("get_api_base_path return the default path by default", {
  Sys.unsetenv("DIDOLITE_API_BASE_PATH")
  path <- default_api_base_path

  expect_equal(get_api_base_path(), path)
})

test_that("get_api_base_path return the DIDOLITE_API_BASE_PATH if configured in env", {
  path <- "http://envvar"
  Sys.setenv(DIDOLITE_API_BASE_PATH = path)

  expect_equal(get_api_base_path(), path)

  Sys.unsetenv("DIDOLITE_API_BASE_PATH")
})

test_that("get_api_base_path return the set path if configured", {
  Sys.setenv(DIDOLITE_API_BASE_PATH = "some path")
  path <- "http://set_api_base_path"
  set_api_base_path(path)

  expect_equal(get_api_base_path(), path)
})

test_that("set_api_base_path can remove configuration", {
  Sys.unsetenv("DIDOLITE_API_BASE_PATH")
  path <- "http://set_api_base_path"
  set_api_base_path(path)
  set_api_base_path(NULL)

  expect_equal(get_api_base_path(), default_api_base_path)
})
