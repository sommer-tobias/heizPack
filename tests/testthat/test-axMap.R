test_that("multiplication works", {
  direction <- 'transformAxis'
  input <-  c(800, 900, 1000)
  ax1 <- c(80,100)
  ax2 <- c(700, 1300)
  axMap(input, ax1, ax2, direction)
  expect_equal(axMap(input, ax1, ax2, direction), c(22300, 25300, 28300))
})
