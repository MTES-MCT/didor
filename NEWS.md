# didor 0.0.3.9000

evol :

* `get_data` now writes the downloaded csv files. Default is `tempdir()` but user can choose with 
  `directory` argument.
* add a new tutorial (credit to Olivier Chantrel)

minor :

* migrate to pkgdown 2
* typo in README.Rmd
* fix warnings from new dplyr release
* fix bug in tests

# didor 0.0.2.9000

* add a user agent "https://github.com/MTES-MCT/didor" to HTTP requests
* fix utf8 bug on windows when reading test file
* fix clean env when changing api_base_path
* refactoring

# didor 0.0.1.9000

* first version
