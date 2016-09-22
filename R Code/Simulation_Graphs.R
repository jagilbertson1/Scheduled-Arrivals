library(ggplot2)

setwd("~/Documents/Scheduled-Arrivals/R\ Code")

# import data
data = read.csv(file = "../Python\ Code/Simulation_Output.csv", header = TRUE, sep = ",")

# construct static data frame
static = data[data$schedule == 'static',]
static = static[order(static$run),]

# construct dynamic data frame
dynamic = data[data$schedule == 'dynamic',]
dynamic = dynamic[order(dynamic$run),]

# construct difference data frame
diff = static[,c(-1,-2)] - dynamic[,c(-1,-2)]

# cost histograms
ggplot(data = static, aes(static$Cost)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(5, 30, by = 0.5), col = "red", fill = "green", alpha = 0.2) + 
  xlim(c(5, 30)) + ylim(c(0, 0.15))

ggplot(data = dynamic, aes(dynamic$Cost)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(5, 30, by = 0.5), col = "red", fill = "green", alpha = 0.2) + 
  xlim(c(5, 30)) + ylim(c(0, 0.15))

ggplot(data = diff, aes(diff$Cost)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(-5, 10, by = 0.25), col = "red", fill = "green", alpha = 0.2) + 
  xlim(c(-5, 10)) + ylim(c(0,0.1))

# average customer waiting time histograms
ggplot(data = static, aes(static$TWT/15)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(0, 2, by = 0.05), col = "red", fill = "green", alpha = 0.2) +
  xlim(c(0, 2)) + ylim(c(0, 0.15))

ggplot(data = dynamic, aes(dynamic$TWT/15)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(0, 2, by = 0.05), col = "red", fill = "green", alpha = 0.2) +
  xlim(c(0, 2)) + ylim(c(0, 0.15))

ggplot(data = diff, aes(diff$TWT/15)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(-0.5, 1, by = 0.025), col = "red", fill = "green", alpha = 0.2) +
  xlim(c(-0.5, 1)) + ylim(c(0, 0.15))

# total service time histograms
ggplot(data = static, aes(static$TST)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(10, 35, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  xlim(c(10, 35)) + ylim(c(0, 0.25))

ggplot(data = dynamic, aes(dynamic$TST)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(10, 35, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  xlim(c(10, 35)) + ylim(c(0, 0.25))

ggplot(data = diff, aes(diff$TST)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(-5, 10, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  xlim(c(-5, 10)) + ylim(c(0, 0.2))

# total idle time histograms
ggplot(data = static, aes(static$TIT)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(0, 20, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  xlim(c(0, 20)) + ylim(c(0, 0.15))

ggplot(data = dynamic, aes(dynamic$TIT)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(0, 20, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  xlim(c(0, 20)) + ylim(c(0, 0.15))

ggplot(data = diff, aes(diff$TIT)) +
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(-5, 10, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  xlim(c(-5, 10)) + ylim(c(0, 0.2))