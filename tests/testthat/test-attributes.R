test_that("set_attributes works", {
  data <- tribble(
    ~NAME,
    "nom",
  )
  columns <- tribble(
    ~name, ~description, ~type, ~format, ~unit,
    "ANNEE", "année", "year", NA, "n/a",
    "NAME", "name", "string", NA, "n/a"
  )
  metadata <- build_attributes(columns)

  a <- set_attributes(data, metadata)

  attributes <- attributes(a$NAME)
  expected <- list(
    name = c("NAME"),
    description = c("name"),
    unit = c("n/a"),
    type = c("string"),
    converted = c(FALSE)
  )

  expect_equal(attributes, expected)
})

test_that("set_attributes fails on data argument errors", {
  expect_error(set_attributes(), "is mandatory")
  expect_error(set_attributes(c(1, 2)), "must be a dataframe")
})
