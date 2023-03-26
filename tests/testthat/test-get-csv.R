file <- tempfile()
file.create(file)

test_that("should_remove_cached_file return FALSE if file does not exist", {
  expect_false(should_remove_cached_file(tempfile()))
})

test_that("should_remove_cached_file return TRUE if last_modified is not passed", {
  expect_true(should_remove_cached_file(file))
})

test_that("should_remove_cached_file return FALSE if mtime is older than last_modified", {
  in_the_past <- format_ISO8601(now() - minutes(5), usetz = TRUE)

  expect_false(should_remove_cached_file(file, in_the_past))
})

test_that("should_remove_cached_file return TRUE if last_modified is more recent than mtime", {
  in_the_future <- format_ISO8601(now() + minutes(5), usetz = TRUE)

  expect_true(should_remove_cached_file(file, in_the_future))
})

test_that("get_columns_from_query works", {
  query <- NULL
  expect_null(get_columns_from_query(query))

  query <- c(other_columns = "DEPARTEMENT_CODE,ESSENCE_M3")
  expect_null(get_columns_from_query(query))

  query <- c(columns = "DEPARTEMENT_CODE,ESSENCE_M3")
  expect_equal(
    get_columns_from_query(query),
    c("DEPARTEMENT_CODE","ESSENCE_M3")
  )
})
