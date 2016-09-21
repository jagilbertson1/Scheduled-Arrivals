library(ggplot2)

setwd("~/Documents/Scheduled-Arrivals/R\ Code")

# import data
data = read.csv(file = "../Python\ Code/Simulation_Output.csv", header = TRUE, sep = ",")

View(data)