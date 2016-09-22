library(ggplot2)

setwd("~/Documents/Scheduled-Arrivals/R\ Code")

# import data
data = read.csv(file = "../Python\ Code/Simulation_Output.csv", header = TRUE, sep = ",")

View(data)

# histograms
hist(data[data$schedule == 'static','Cost'], breaks = 50, freq = FALSE, xlim = c(0, 30))
hist(data[data$schedule == 'dynamic','Cost'], breaks = 50, freq = FALSE, xlim = c(0, 30))
hist(data[data$schedule == 'static','Cost'] - data[data$schedule == 'dynamic','Cost'], breaks = 100, freq = FALSE, xlim = c(-10, 10))