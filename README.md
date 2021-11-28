DiDo R package
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

# DiDoR

<!-- badges: start -->

[<img src="https://www.repostatus.org/badges/latest/wip.svg" target="_blank" alt="Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public." />](https://www.repostatus.org/#wip)
[![R-CMD-check](https://github.com/nbc/didor/workflows/R-CMD-check/badge.svg)](https://github.com/nbc/didor/actions)
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
devtools::install_github("nbc/didor")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(didor)
library(tidyverse)

result <- datasets() %>%
  dido_search("produit-petrolier") %>%
  datafiles() %>%
  dido_search("drom") %>%
  get_data()
knitr::kable(head(result))
```

| DEPARTEMENT\_CODE | DEPARTEMENT\_LIBELLE | REGION\_CODE | REGION\_LIBELLE | ANNEE | ESSENCE\_M3 | GAZOLE\_M3 | FIOUL\_M3 | GPL\_M3 | CARBUREACTEUR\_M3 |
|:------------------|:---------------------|:-------------|:----------------|:------|:------------|:-----------|:----------|:--------|:------------------|
| 971               | Guadeloupe           | 01           | Guadeloupe      | 2020  | 112378      | 187242     | 273707    | 21455   | 96587             |
| 972               | Martinique           | 02           | Martinique      | 2020  | 115415      | 167795     | 372927    | 17777   | 77281             |
| 973               | Guyane               | 03           | Guyane          | 2020  | 34904       | 103757     | 118452    | 8882    | 28400             |
| 974               | La Réunion           | 04           | La Réunion      | 2020  | 129677      | 445872     | 202724    | 38551   | 168824            |
| 976               | Mayotte              | 06           | Mayotte         | 2020  | 19592       | 124040     | NA        | 10852   | 6044              |
| 971               | Guadeloupe           | 01           | Guadeloupe      | 2019  | 128464      | 217934     | 233765    | 21539   | 160846            |

See

-   the [Tutorial](articles/premiers_pas.html) for more information and
    examples.
-   An [example](articles/drawing_energie.html) for more information and
    examples.
