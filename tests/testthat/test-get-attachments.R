get_metadata()

test_that("check fail if arg isn't a dataframe ", {
  data <- c("a", "b")
  expect_error(get_attachments(data), "must be a dataframe")
})

test_that("check fail if arg isn't a dataframe ", {
  data <- tibble(
    name = c("a", "b")
  )
  expect_error(get_attachments(data), "data must have")
})

test_that("check get_attachments", {
  skip_on_cran()
  skip_if_offline()
  urls <- datasets() %>%
    attachments() %>%
    select(url) %>%
    slice(1)

  expect_message(get_attachments(urls, dest = tempdir()), "downloaded")
})
