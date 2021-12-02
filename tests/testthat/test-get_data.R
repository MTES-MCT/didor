test_that("get_data works with last_millesime input", {
  skip_on_cran()
  skip_if_offline()

  get_metadata()

  data <- datasets() %>%
    datafiles() %>%
    last_millesime() %>%
    arrange(rows) %>%
    slice_head()
  nb_of_rows <- data[["rows"]]
  result <- get_data(data)

  expect_equal(nb_of_rows, nrow(result))

  for (col in names(result)) {
    expect_named(attributes(result[[col]]), c("name", "description", "unit", "type", "converted"))
  }
})

test_that("get_data works with datafiles input", {
  skip_on_cran()
  skip_if_offline()

  get_metadata()

  data <- datasets() %>%
    datafiles() %>%
    last_millesime() %>%
    arrange(rows) %>%
    slice_head()
  nb_of_rows <- data[["rows"]]
  result <- get_data(data %>% select(rid))

  expect_equal(nb_of_rows, nrow(result))
})

test_that("get_data works with concat FALSE", {
  skip_on_cran()
  skip_if_offline()

  get_metadata()

  data <- datasets() %>%
    datafiles() %>%
    last_millesime() %>%
    arrange(rows) %>%
    slice_head()
  result <- get_data(data %>% select(rid), concat = FALSE)

  expect_output(str(result), "List of 1")

  for (col in names(result[[1]])) {
    expect_named(attributes(result[[1]][[col]]), c("name", "description", "unit", "type", "converted"))
  }
})

test_that("get_data returns NULL or list() when feeded empty tibble", {
  skip_on_cran()
  skip_if_offline()

  get_metadata()

  data <- datafiles() %>%
    dido_search("no such string will ever exists")
  result_not_concat <- get_data(data %>% select(rid), concat = FALSE)
  result_concat <- get_data(data %>% select(rid))

  expect_output(str(result_not_concat), "list()")
  expect_equal(result_concat, NULL)
})

test_that("get_data fail", {
  expect_error(get_data(), "is mandatory")
  expect_error(get_data(c("a")), "must be a dataframe")
  expect_error(get_data(tibble(name = c(1, 2))), "must have an")
})
