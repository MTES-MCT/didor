test_that("build_url works without params", {
  set_api_base_path("path")

  expect_equal(
    build_url("/my", query = c(page = 1, size = 1)),
    "path/my?page=1&size=1"
  )

  expect_equal(build_url("/my"), "path/my")

  expect_equal(
    build_url("/my", default_query = c(size = "default")),
    "path/my?size=default"
  )

  expect_equal(
    build_url("/my",
      default_query = c(size = "default"),
      query = c(size = "user")
    ),
    "path/my?size=user"
  )
})

test_that("stringify_query works", {
  expect_equal(stringify_query(list()), "")

  query <- c(columns = "DEPARTEMENT_CODE,ESSENCE_M3", DEPARTEMENT_CODE = "eq:971")
  expect_equal(stringify_query(query), "-columns=DEPARTEMENT_CODE,ESSENCE_M3;DEPARTEMENT_CODE=eq971")

  query <- list(columns = "DEPARTEMENT_CODE,ESSENCE_M3", DEPARTEMENT_CODE = "eq:971")
  expect_equal(stringify_query(query), "-columns=DEPARTEMENT_CODE,ESSENCE_M3;DEPARTEMENT_CODE=eq971")

})
