get_metadata("datasets.json")

# last_millesime

test_that("last_millesime works when multiple millesimes", {
  last <- datafiles() %>%
    filter(rid == "49b4b29b-3d0b-43bb-879d-244aeceb876f") %>%
    last_millesime()
  expect_equal(nrow(last), 1)
  expect_equal(last[["millesime"]], "2021-11")
})

test_that("last_millesimes works when only one", {
  last <- datafiles() %>%
    filter(rid == "ae6666a6-097d-48c1-845a-1d52eca375e6") %>%
    last_millesime()
  expect_equal(nrow(last), 1)
})

test_that("last_millesimes works when only one", {
  last <- datafiles() %>%
    filter(rid == "ae6666a6-097d-48c1-845a-1d52eca375e6") %>%
    last_millesime()
  expect_equal(nrow(last), 1)
})

test_that("last_millesimes returns an empty tibble no millesime", {
  last <- datafiles() %>%
    filter(rid == "AAAAA") %>%
    last_millesime()
  expect_equal(nrow(last), 0)
})

test_that("last_millesime() stop if wrong input data", {
  expect_error(tibble() %>% last_millesime(), "data must have")
  expect_error(c(11, 22) %>% last_millesime(), "data must be a dataframe")
})

# columns

test_that("columns works", {
  expect_message(col <- datafiles() %>%
    filter(id == "618cfa72aac4a70022253bbb") %>%
    columns() %>%
    replace_na(list(format = "-")),
    "datafiles: 4")

  expect_equal(nrow(col), 3)

  result <- tibble(
    name = c("CONSO", "ENERGIE", "PRODUCTEUR"),
    description = c("consommation", "energie (gaz, électricité)", "producteur"),
    type = c("number", "string", "string"),
    format = c("-", "-", "-"),
    unit = c("MW/h", "n/a", "n/a"),
    `nb of occurrences` = c(4, 4, 4)
  )

  expect_equal(col, result)
})

test_that("columns() stop if multiple millesimes per datafiles", {
  expect_error(datafiles() %>%
                 millesimes() %>%
                 columns(),
               "include more than one millesime")
})

test_that("columns() stop if wrong input data", {
  expect_error(tibble() %>% columns(), "data must have")
  expect_error(c(11, 22) %>% columns(), "data must be a dataframe")
})

# millesimes

test_that("millesime fails if error", {
  expect_error(millesimes(), "need an argument")
  expect_error(millesimes(c(1,2,3)), "must be a dataframe")

  data <- tibble(row = c(1,2,3))
  expect_error(millesimes(data), "`rid` column")
})

test_that("millesime works", {
  millesimes <- datafiles() %>%
    filter(rid == "49b4b29b-3d0b-43bb-879d-244aeceb876f") %>%
    millesimes()

  expect_equal(names(millesimes),
               c("rid", "id", "millesime", "date_diffusion", "rows",
                 "columns", "extendedFilters", "geoFields", "refs"))
  expect_equal(nrow(millesimes), 2)
})
