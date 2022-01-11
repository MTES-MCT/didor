test_that("get_csv works", {
  mock <- mockery::mock()
  mockery::stub(get_csv, "http_get", mock)

  result <- get_csv("a")

  mockery::expect_called(mock, 1)
  args <- mockery::mock_args(mock)
  expect_equal(
    args[[1]][[1]],
    "https://data.statistiques.developpement-durable.gouv.fr/dido/api/v1/datafiles/a/csv?withColumnName=TRUE&withColumnDescription=FALSE&withColumnUnit=FALSE"
  )
})
