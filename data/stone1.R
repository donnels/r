# stone dropped in well 6 seconds till thud (no splash)
#!/usr/bin/env Rscript
# get filename to work on
# test if there is at least one argument: if not, return an error
if (interactive()) {
  interactive <- interactive()
  #probably running on my laptop so set these manually for testing through gui (rstudio)
  filename <- "stoneDrop.svg"
  setwd("/Users/seandonnellan/Documents/Github/donnels/r/data")
} else {
  #probably running in a docker or similar
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args)==0) {
    stop("At least one argument must be supplied (input file)", call.=FALSE)
  } else {
    filename <- args[1]
  }
}
svg(file = filename )

vars <- data.frame( echo = 6, g = 9.8, v_snd = 340)
t <- seq(0, vars$echo , length.out = 10000) # time interval of ECHO seconds and n points
df <- data.frame( t = t,
  ix_sound = rev(vars$v_snd * t), # ... and the sound backwards in time
  x = 1/2 * vars$g * t^2 ) # Calculate distance traveled by the stone forwards in time ... 
# Plot the motion of the stone 
plot(df$t, df$x, type = "l", xlab = "Time (s)", ylab = "Distance (m)",
     main = "Motion of a Falling Stone and Reflected Sound Waves")
text(0, 0, "Drop", adj = c(0,1), cex = .75) # the dropping point
points(0, 0, col="blue") # drop label
text(vars$echo, 0, "Echo", adj = c(1,1), cex = .75) # the sound heard
points(vars$echo, 0, col="blue") # echo label
lines(df$t, df$ix_sound, col = "red") # plot Sound running back in time
df$diff_dist <- abs(df$x - df$ix_sound) # Calculate the difference between the distances traveled
result <- data.frame( x_t = df$t[which.min(df$diff_dist)], x_m = df$x[which.min(df$diff_dist)] )
abline(h = result$x_m, lty="dotted") # plot the y intersect
points(result$x_t, result$x_m, col="green", pch=19) # plot the intersect point
text(result$x_t, result$x_m, sprintf("(%.2f s, %.2f m) ", result$x_t, result$x_m), adj=c(1,0)) # add the label
text(0, (max(df$x)/2), paste("Gravity: ", vars$g, "m/s^2"), adj=c(0,0), cex = .75) # add var values
text(0, (max(df$x)/2.25), paste("Speed of sound: ", vars$v_snd, "m/s"), adj=c(0,1), cex = .75) # add var values

dev.off()