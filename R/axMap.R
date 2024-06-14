axMap = function(input, ax1, ax2, direction){

  # direction = 'transformAxis'
  # input = c(800, 900, 1000)
  # ax1 <- c(80,100)
  # ax2 <- c(700, 1300)

  diffAx1 <- diff(ax1)
  diffAx2 <- diff(ax2)

  ratDiff <- diffAx2/diffAx1


  if (direction %in% 'transformAxis') {
    output <- (input - ax1[1])*ratDiff + ax2[1]
  } else if (direction %in% 'transformValues') {
    output <- (input - ax2[1])/ratDiff + ax1[1]
  }

  output
  return(output)
}
