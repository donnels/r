#!/usr/bin/env Rscript
# get filename to work on
# test if there is at least one argument: if not, return an error
if (interactive()) {
  interactive <- interactive()
  #probably running on my laptop so set these manually for testing through gui (rstudio)
  filename <- "heating.svg"
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

#Load Libraries
libs = c("ggplot2")
for (i in libs){
  if( !is.element(i, .packages(all.available = TRUE)) ) {
    install.packages(i)
  }
  library(i,character.only = TRUE)
}


# Create a data frame from the given time and pressure readings
data <- data.frame(
  time = c("12:54", "13:01", "13:18", "13:22", "13:29", "13:37", "13:55", "14:17", "14:20", "14:27", "14:29", "14:46", "14:50", "15:15", "15:19", "16:10", "17:51", "18:01", "18:10", "18:29", "18:35", "19:58", "22:57", "23:08"),
  pressure = c(1.7, 1.5, 1.3, 1.25, 1.2, 1.18, 1.1, 1.0, 0.99, 1.7, 1.65, 1.55, 1.52, 1.4, 1.35, 1.25, 0.95, 0.91, 1.99, 1.91, 1.89, 1.61, 1.2, 2)
)

# Convert time column to POSIXct format
data$time <- as.POSIXct(data$time, format = "%H:%M")
  

# Plot the time-based pressure drop
p <- ggplot(data, aes(x = time, y = pressure)) +
  geom_line() +
  labs(title = "Time-based Pressure Drop",
       x = "Time",
       y = "Pressure") +
  theme_minimal()

# Save the plot as an SVG file
ggsave(filename, plot = p, device = "png")