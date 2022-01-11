get_metadata("datasets.json")

test_that("dido_search works", {
  result <- datasets() %>% dido_search("DROM")

  expect_equal(nrow(result), 1)
  expect_equal(pull(result, "title"), "Consommation DROM")
})

test_that("dido_search is case insensitive", {
  result <- datasets() %>% dido_search("drom")

  expect_equal(nrow(result), 1)
  expect_equal(pull(result, "title"), "Consommation DROM")
})

test_that("dido_search failed if pattern doesn't exists", {
  result <- datasets() %>% dido_search("something")

  expect_equal(nrow(result), 0)
})
