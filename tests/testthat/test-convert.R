columns <- tribble(
  ~name, ~description, ~type, ~format,
  "ANNEE", "annee", "year", NA,
  "NUMBER", "number", "number", NA,
  "INTEGER", "integer", "integer", NA
) %>% mutate(format = as.character(format))

attributes <- build_attributes(columns)

test_that("convert works", {
  test_tb <- readr::read_delim("test-convert-simple.csv",
    delim = ";",
    locale = locale(decimal_mark = "."),
    col_types = cols(.default = "c")
  )
  test_tb <- set_attributes(test_tb, attributes)

  expected_result <- tribble(
    ~ANNEE, ~NUMBER, ~INTEGER,
    "2018", -0.0013, 1
  )

  converted <- convert(test_tb)
  expect_true(all.equal(expected_result, converted, check.attributes = FALSE))

  # test a second conversion
  converted <- convert(converted)
  expect_true(all.equal(expected_result, converted, check.attributes = FALSE))
})

test_that("convert works with secretize values", {
  test_tb <- readr::read_delim("test-convert-secret.csv",
    delim = ";",
    locale = locale(decimal_mark = "."),
    col_types = cols(.default = "c")
  )
  test_tb <- set_attributes(test_tb, attributes)

  expected_result <- tribble(
    ~ANNEE, ~NUMBER, ~INTEGER,
    "2018", NA, 1,
    "2018", 1.2, 1
  )

  converted <- convert(test_tb)
  expect_true(all.equal(expected_result, converted, check.attributes = FALSE))

  # test a second conversion
  # converted <- convert(converted)
  # expect_true(all.equal(expected_result, converted, check.attributes = FALSE))
})

test_that("convert send message when unable to convert", {
  test_tb <- readr::read_delim("test-convert-simple.csv",
    delim = ";",
    locale = locale(decimal_mark = "."),
    col_types = cols(.default = "c")
  )
  expect_message(convert(test_tb), "Unable to convert")
})


test_that("convert fails", {
  expect_error(convert(), "is mandatory")
  expect_error(convert(c(1, 2)), "must be a dataframe")
})
