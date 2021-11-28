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
