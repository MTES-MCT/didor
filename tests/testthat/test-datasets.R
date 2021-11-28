get_metadata("datasets.json")

test_that("datasets() get all datasets works", {
  result <- datasets()
  expect_true(is_tibble(result))

  expect_equal(nrow(result), 3)
})

test_that("datasets() get all datasets works", {
  result <- datasets()
  expect_true(is_tibble(result))

  expect_equal(nrow(result), 3)
})

test_that("datasets() can use datafiles() as input", {
  result <- datafiles() %>%
    dido_search("drom") %>%
    datasets()

  expect_true(is_tibble(result))
  expect_equal(nrow(result), 1)
})


test_that("datasets() stop if wrong input data", {
  expect_error(tibble() %>% datasets(), "data must have")
  expect_error(c(11, 22) %>% datasets(), "data must be a dataframe")
})
