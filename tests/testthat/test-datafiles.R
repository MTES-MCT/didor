get_metadata("datasets.json")

test_that("datafiles() returns all datafiles", {
  result <- datafiles()

  expect_true(is_tibble(result))
  expect_equal(nrow(result), 7)
})

test_that("datafiles() can be feeded by datasets", {
  result <- datasets() %>% datafiles()

  expect_true(is_tibble(result))
  expect_equal(nrow(result), 7)
})

test_that("datafiles() can be feeded by datasets", {
  result <- datasets() %>%
    dido_search("drom") %>%
    datafiles()

  expect_true(is_tibble(result))
  expect_equal(nrow(result), 1)
})

test_that("datafiles() stop if wrong input data", {
  expect_error(tibble() %>% datafiles(), "data must have")
  expect_error(c(11, 22) %>% datafiles(), "data must be a dataframe")
})
