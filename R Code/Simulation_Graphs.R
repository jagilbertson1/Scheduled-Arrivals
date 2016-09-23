library(ggplot2)
library(reshape2)

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
png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Cost_Hist_Static.png")
ggplot(data = static, aes(static$Cost)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(5, 30, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(static$Cost), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(static$Cost,0.025), quantile(static$Cost,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(5, 30)) + ylim(c(0, 0.15))
dev.off()

png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Cost_Hist_Dynamic.png")
ggplot(data = dynamic, aes(dynamic$Cost)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(5, 30, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(dynamic$Cost), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(dynamic$Cost,0.025), quantile(dynamic$Cost,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(5, 30)) + ylim(c(0, 0.15))
dev.off()

png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Cost_Hist_Diff.png")
ggplot(data = diff, aes(diff$Cost)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(-5, 10, by = 0.25), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(diff$Cost), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(diff$Cost,0.025), quantile(diff$Cost,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(-5, 10)) + ylim(c(0,0.1))
dev.off()

# average customer waiting time histograms
png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/WT_Hist_Static.png")
ggplot(data = static, aes(static$TWT/15)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(0, 2.5, by = 0.05), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(static$TWT/15), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(static$TWT/15,0.025), quantile(static$TWT/15,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(0, 2.5)) + ylim(c(0, 0.15))
dev.off()

png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/WT_Hist_Dynamic.png")
ggplot(data = dynamic, aes(dynamic$TWT/15)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(0, 2.5, by = 0.05), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(dynamic$TWT/15), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(dynamic$TWT/15,0.025), quantile(dynamic$TWT/15,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(0, 2.5)) + ylim(c(0, 0.15))
dev.off()

png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/WT_Hist_Diff.png")
ggplot(data = diff, aes(diff$TWT/15)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(-0.5, 1, by = 0.025), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(diff$TWT/15), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(diff$TWT/15,0.025), quantile(diff$TWT/15,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(-0.5, 1)) + ylim(c(0, 0.15))
dev.off()

# total service time histograms
png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/TST_Hist_Static.png")
ggplot(data = static, aes(static$TST)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(10, 35, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(static$TST), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(static$TST,0.025), quantile(static$TST,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(10, 35)) + ylim(c(0, 0.25))
dev.off()

png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/TST_Hist_Dynamic.png")
ggplot(data = dynamic, aes(dynamic$TST)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(10, 35, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(dynamic$TST), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(dynamic$TST,0.025), quantile(dynamic$TST,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(10, 35)) + ylim(c(0, 0.25))
dev.off()

png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/TST_Hist_Diff.png")
ggplot(data = diff, aes(diff$TST)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(-5, 10, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(diff$TST), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(diff$TST,0.025), quantile(diff$TST,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(-5, 10)) + ylim(c(0, 0.2))
dev.off()

# total idle time histograms
png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/TIT_Hist_Static.png")
ggplot(data = static, aes(static$TIT)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(0, 20, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(static$TIT), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(static$TIT,0.025), quantile(static$TIT,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(0, 20)) + ylim(c(0, 0.15))
dev.off()

png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/TIT_Hist_Dynamic.png")
ggplot(data = dynamic, aes(dynamic$TIT)) + 
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(0, 20, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(dynamic$TIT), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(dynamic$TIT,0.025), quantile(dynamic$TIT,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(0, 20)) + ylim(c(0, 0.15))
dev.off()

png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/TIT_Hist_Diff.png")
ggplot(data = diff, aes(diff$TIT)) +
  geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(-5, 10, by = 0.5), col = "red", fill = "green", alpha = 0.2) +
  geom_vline(xintercept = median(diff$TIT), colour = "black", size = 2) +
  geom_vline(xintercept = c(quantile(diff$TIT,0.025), quantile(diff$TIT,0.975)), colour = "blue", linetype = 'longdash') +
  xlim(c(-5, 10)) + ylim(c(0, 0.2))
dev.off()

# waiting times table
waitTimes = melt(data[,c(1:2,18:32)], id = c('run','schedule'))
colnames(waitTimes) = c('run', 'schedule', 'customer', 'waiting_time')
waitTimes$customer = as.numeric(unlist(strsplit(as.character(waitTimes$customer), split = '[.]'))[seq(from = 2,
                                                                                            to = 2 * nrow(waitTimes), by = 2)])

# line plot of mean waiting time for each customer
png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/WT_Line_Avg.png")
ggplot(data = waitTimes, aes(x = customer, y = waiting_time, group = schedule, colour = schedule)) +
  stat_summary(fun.y = "mean", geom = "point") +
  stat_summary(fun.y = "mean", geom = 'line')
dev.off()

# line plot of proportion no waiting time for each customer
png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/WT_Line_Prop.png")
ggplot(data = waitTimes, aes(x = customer, y = waiting_time, group = schedule, colour = schedule)) +
  stat_summary(fun.y = function(x) mean(x==0), geom = "point") +
  stat_summary(fun.y = function(x) mean(x==0), geom = 'line')
dev.off()

# arrival times table
arrivalTimes = melt(data[,c(1:17)], id = c('run','schedule'))
colnames(arrivalTimes) = c('run', 'schedule', 'customer', 'arrival_time')
arrivalTimes$customer = as.numeric(unlist(strsplit(as.character(arrivalTimes$customer), split = '[.]'))[seq(from = 2,
                                                                                            to = 2 * nrow(arrivalTimes), by = 2)])

# line plot of mean arrival time for each customer
png(file = "~/Documents/Scheduled-Arrivals/Thesis/Figures/AT_Line.png")
ggplot(data = arrivalTimes, aes(x = customer, y = arrival_time, group = schedule, colour = schedule)) +
  stat_summary(fun.y = "mean", geom = "point") +
  stat_summary(fun.y = "mean", geom = 'line')
dev.off()