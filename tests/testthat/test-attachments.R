get_metadata("datasets.json")

test_that("attachments() works alone", {
  result <- attachments()

  expect_true(is_tibble(result))
  expect_equal(nrow(result), 2)
})

test_that("attachments() works on datasets() input", {
  result <- datasets() %>%
    filter(id == "618cfa72aac4a70022253bbb") %>%
    attachments()

  expect_true(is_tibble(result))
  expect_equal(nrow(result), 2)
})

test_that("attachments() works on datasets() input", {
  result <- datasets() %>%
    filter(id == "618cfa72aac4a70022253bbb") %>%
    attachments()

  expect_true(is_tibble(result))
  expect_equal(nrow(result), 2)
})

test_that("attachments() stop if wrong input data", {
  expect_error(tibble() %>% attachments(), "data must have")
  expect_error(c(11, 22) %>% attachments(), "data must be a dataframe")
})
