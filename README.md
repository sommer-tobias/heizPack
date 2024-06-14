
<!-- README.md is generated from README.Rmd. Please edit that file -->

# heizPack

<!-- badges: start -->
<!-- badges: end -->

The goal of heizPack is to illustrate changes in the heating system

## Installation

You can install the development version of heizPack from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("sommer-tobias/heizPack")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(heizPack)
direction <- 'transformAxis'
input <-  c(800, 900, 1000)
ax1 <- c(80,100)
ax2 <- c(700, 1300)
axMap(input, ax1, ax2, direction)
#> [1] 22300 25300 28300
```
