#!/usr/bin/env Rscript
# get filename to work on
# test if there is at least one argument: if not, return an error
if (interactive()) {
  interactive <- interactive()
  #probably running on my laptop so set these manually for testing through gui (rstudio)
  filename <- "normalDist.svg"
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
# Create a data frame with x values
df <- data.frame(x = seq(-4, 4, length.out = 1000))
# Add a column with the density values
df$density <- dnorm(df$x)
# Find the density values at z-scores of different values
x_vals <- c(1,2,3)
roundn <- 4
density_vals <- dnorm(x_vals)
percent_vals <- round(pnorm(x_vals) - pnorm(x_vals*-1), 4)*100
isectdf <- data.frame(cbind(x = x_vals, density = density_vals, percent = percent_vals))
colnames(isectdf) <- c("x", "density","percent")
# Define color cutoffs for the density plot
labeldf <- data.frame(
  'colors' = c("red", "orange", "yellow", "green", "blue", "purple"),
  'percent' = c(round(pnorm(2,lower.tail=F)*100,roundn),
                round((pnorm(1,lower.tail=F)-pnorm(2,lower.tail=F))*100,roundn), 
                round((pnorm(0,lower.tail=F)-pnorm(1,lower.tail=F))*100,roundn), 
                round((pnorm(0,lower.tail=F)-pnorm(1,lower.tail=F))*100,roundn), 
                round((pnorm(1,lower.tail=F)-pnorm(2,lower.tail=F))*100,roundn), 
                round(pnorm(2,lower.tail=F)*100,roundn) ), 
  'percentxPos' = c(-3, -1.5, -0.5, .5, 1.5, 3 ), 
  'labels1' = c("-Inf to -2", "2 to -1", "-1 to 0", "0 to 1", "1 to 2", "2 to Inf"), 
  'labels' = c("<= -2", "-2 to -1", "-1 to 0", "0 to 1", "1 to 2", ">= 2")) 
color_cutoffs <- c(-Inf, -2, -1, 0, 1, 2, Inf)
# Add a column with color categories
df$category <- cut(df$x, breaks = color_cutoffs, labels = labeldf$labels)
plot <- ggplot(df, aes(x, density)) +
  geom_area(aes(fill = category), alpha = 0.5) + geom_line(size = 1.2) +
  scale_fill_manual(values = labeldf$colors, labels = labeldf$labels) +
  geom_vline(linetype = "dashed", color = "lightblue", xintercept = c(isectdf$x,isectdf$x*-1)) +
  geom_text(data=isectdf, x = isectdf$x, y = .4, aes( label = x)) +
  geom_text(data=isectdf, x = isectdf$x*-1, y = .4, aes( label = x*-1)) +
  geom_hline(linetype = "dashed", color = "blue", yintercept = isectdf$density) +
  geom_text(data=isectdf, x = 0, y = isectdf$density+.007, size = 4, aes( label = paste0(percent, "%"))) +
  geom_text(data=labeldf, x = labeldf$percentxPos, y = -.007, size = 4, aes( label = percent )) +
  xlab("Z-score") + ylab("Density") +   theme_classic() +
  ggtitle("Normal Distribution with Highlighted Sections") +
  labs(caption = "©2023 VSR - Author Sean Donnellan)")

if (interactive()) {plot}
svg(file = filename )
plot
dev.off()
