test_that("download_attachments fails if dest dir doesnt't exists", {
  skip_on_cran()
  skip_if_offline()

  get_metadata()

  expect_error(download_attachment(
    "http://falseurl.com",
    dest = "/a/directory/that/doesnt/exists"
  ), "doesn't exists")
})

test_that("download_attachments fails if dest dir doesnt't exists", {
  skip_on_cran()
  skip_if_offline()

  get_metadata()

  url <- "https://data.statistiques.developpement-durable.gouv.fr/dido/api/files/bad-id"

  expect_error(download_attachment(url), "Erreur de validation: Le champ rid")
})

test_that("download_attachments works on real attachment", {
  skip_on_cran()
  skip_if_offline()

  get_metadata()

  urls <- datasets() %>%
    attachments() %>%
    select(url) %>%
    slice(1)
  tmp <- tempdir()
  expect_message(download_attachment(urls[["url"]], dest = tmp), "ownloaded")
})
