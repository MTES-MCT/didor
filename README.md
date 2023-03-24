DiDo R package
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

# DiDoR

<!-- badges: start -->

[<img src="https://www.repostatus.org/badges/latest/wip.svg"
target="_blank"
alt="Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public." />](https://www.repostatus.org/#wip)
[![R-CMD-check](https://github.com/MTES-MCT/didor/workflows/R-CMD-check/badge.svg)](https://github.com/MTES-MCT/didor/actions/workflows/check-release.yaml)
[![Codecov test
coverage](https://codecov.io/gh/nbc/didor/branch/main/graph/badge.svg)](https://codecov.io/gh/nbc/didor?branch=main)
<!-- badges: end -->

R library to explore and access data published by
[CGDD/SDES](https://www.statistiques.developpement-durable.gouv.fr/) on
<https://data.statistiques.developpement-durable.gouv.fr/dido/api/v1/apidoc.html>

## Installation

There’s no released version of didor on
[CRAN](https://CRAN.R-project.org).

You can install development version from GitHub:

``` r
# Install from GitHub
library(devtools)
devtools::install_github("mtes-mct/didor")
```

## Example

``` r
library(didor)
library(tidyverse)

result <- datasets() %>%
  dido_search("produit-petrolier") %>%
  datafiles() %>%
  dido_search("drom") %>%
  get_data()
#> Downloading: 340 B     Downloading: 340 B     Downloading: 1.3 kB     Downloading: 1.3 kB     Downloading: 1.3 kB     Downloading: 1.3 kB     Downloading: 1.3 kB     Downloading: 1.3 kB
knitr::kable(head(result))
```

| DEPARTEMENT_CODE | DEPARTEMENT_LIBELLE | REGION_CODE | REGION_LIBELLE | ANNEE | ESSENCE_M3 | GAZOLE_M3 | FIOUL_M3 | GPL_M3 | CARBUREACTEUR_M3 |
|:-----------------|:--------------------|:------------|:---------------|:------|:-----------|:----------|:---------|:-------|:-----------------|
| 971              | Guadeloupe          | 01          | Guadeloupe     | 2021  | 118664     | 190809    | 246583   | 20837  | 107177           |
| 972              | Martinique          | 02          | Martinique     | 2021  | 125134     | 171964    | 377837   | 17536  | 88983            |
| 973              | Guyane              | 03          | Guyane         | 2021  | 39528      | 106097    | 78464    | 8826   | 35147            |
| 974              | La Réunion          | 04          | La Réunion     | 2021  | 151834     | 494126    | 266309   | 38040  | 192811           |
| 976              | Mayotte             | 06          | Mayotte        | 2021  | 22575      | 133408    | 0        | 11427  | 7061             |
| 971              | Guadeloupe          | 01          | Guadeloupe     | 2020  | 112378     | 187242    | 273707   | 21455  | 96587            |

See [this
tutorial](https://mtes-mct.github.io/didor/articles/premiers_pas.html)
[or this
one](https://mtes-mct.github.io/didor/articles/tutoriel_didor.html) and
the [package homepage](https://mtes-mct.github.io/didor/) for more
information and examples.
