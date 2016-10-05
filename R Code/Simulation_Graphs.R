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

# mean of static closely matches expected cost of 15.05
mean(static[,'Cost'])

# mean of dynamic closely matches expected cost of 13.55
mean(dynamic[,'Cost'])

# cost histograms
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Cost_Hist_Static.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = static, aes(static$Cost)) +
         geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(6, 30, by = 0.5), col = "black", fill = "#56B4E9") +
         geom_vline(xintercept = median(static$Cost), colour = "black", size = 2.5) +
         geom_vline(xintercept = c(quantile(static$Cost,0.25), quantile(static$Cost,0.75)), colour = "#0072B2",
                    linetype = 'longdash', size = 1.5) +
         labs(x = 'Static Schedule Cost', y = 'Frequency') +
         scale_x_continuous(breaks = 2*(3:15)) +
         coord_cartesian(ylim = c(0, 0.15)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)))
)

ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Cost_Hist_Dynamic.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = dynamic, aes(dynamic$Cost)) +
         geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(6, 30, by = 0.5), col = "black", fill = "#56B4E9") +
         geom_vline(xintercept = median(dynamic$Cost), colour = "black", size = 2.5) +
         geom_vline(xintercept = c(quantile(dynamic$Cost,0.25), quantile(dynamic$Cost,0.75)), colour = "#0072B2",
                    linetype = 'longdash', size = 1.5) +
         labs(x = 'Dynamic Schedule Cost', y = 'Frequency') +
         scale_x_continuous(breaks = 2*(3:15)) +
         coord_cartesian(ylim = c(0, 0.15)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)))
)

ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Cost_Hist_Diff.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = diff, aes(diff$Cost)) +
         geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(-4, 8, by = 0.25), col = "black", fill = "#56B4E9") +
         geom_vline(xintercept = median(diff$Cost), colour = "black", size = 2.5) +
         geom_vline(xintercept = c(quantile(diff$Cost,0.25), quantile(diff$Cost,0.75)), colour = "#0072B2",
                    linetype = 'longdash', size = 1.5) +
         labs(x = 'Difference in Schedule Cost', y = 'Frequency') +
         scale_x_continuous(breaks = -4:8) +
         coord_cartesian(ylim = c(0, 0.1)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)))
)

# average customer waiting time histogram
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/WT_Hist_Diff.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = diff, aes(diff$TWT/15)) +
         geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(-0.4, 1, by = 0.025), col = "black", fill = "#56B4E9") +
         geom_vline(xintercept = median(diff$TWT/15), colour = "black", size = 2.5) +
         geom_vline(xintercept = c(quantile(diff$TWT/15,0.25), quantile(diff$TWT/15,0.75)), colour = "#0072B2",
                    linetype = 'longdash', size = 1.5) +
         labs(x = 'Difference in Average Customer Waiting Time', y = 'Frequency') +
         scale_x_continuous(breaks = (-2:5)/5) +
         coord_cartesian(ylim = c(0, 0.15)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)))
)

# total service time histograms
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/TST_Hist_Static.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = static, aes(static$TST)) +
         geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(10, 30, by = 0.5), col = "black", fill = "#56B4E9") +
         geom_vline(xintercept = median(static$TST), colour = "black", size = 2.5) +
         geom_vline(xintercept = c(quantile(static$TST,0.25), quantile(static$TST,0.75)), colour = "#0072B2",
                    linetype = 'longdash', size = 1.5) +
         labs(x = 'Total Service Time of Static Schedule', y = 'Frequency') +
         scale_x_continuous(breaks = 2*(5:15)) +
         coord_cartesian(ylim = c(0, 0.25)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)))
)

ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/TST_Hist_Dynamic.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = dynamic, aes(dynamic$TST)) +
         geom_histogram(aes(y=..count../sum(..count..)), breaks = seq(10, 30, by = 0.5), col = "black", fill = "#56B4E9") +
         geom_vline(xintercept = median(dynamic$TST), colour = "black", size = 2.5) +
         geom_vline(xintercept = c(quantile(dynamic$TST,0.25), quantile(dynamic$TST,0.75)), colour = "#0072B2",
                    linetype = 'longdash', size = 1.5) +
         labs(x = 'Total Service Time of Dynamic Schedule', y = 'Frequency') +
         scale_x_continuous(breaks = 2*(5:15)) +
         coord_cartesian(ylim = c(0, 0.25)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)))
)

# waiting times table
waitTimes = data.frame(matrix(c(rep("Static Schedule", 15), rep("Dynamic Schedule", 15)), nrow = 30, ncol = 1))
colnames(waitTimes) = c("schedule")
waitTimes$schedule = factor(waitTimes$schedule, levels = c("Static Schedule", "Dynamic Schedule"))

waitTimes$customer = rep(as.numeric(unlist(strsplit(as.character(colnames(data)[18:32]), split = '[.]'))[seq(from = 2,
                        to = 30, by = 2)]),2)

for (i in 1:15) {
  waitTimes$waiting_time[i] = mean(static[,paste("WT",i,"", sep = ".")])
  waitTimes$waiting_time[i + 15] = mean(dynamic[,paste("WT",i,"", sep = ".")])
  
  waitTimes$no_waiting[i] = mean(static[,paste("WT",i,"", sep = ".")] == 0)
  waitTimes$no_waiting[i + 15] = mean(dynamic[,paste("WT",i,"", sep = ".")] == 0)
}

# line plot of mean waiting time for each customer
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/WT_Line_Avg.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = waitTimes, aes(x = factor(customer), y = waiting_time, group = factor(schedule),
                                      colour = factor(schedule))) +
         stat_summary(fun.y = "mean", geom = "point", size = 3) +
         stat_summary(fun.y = "mean", geom = 'line', size = 1.5) +
         labs(x = "Customer", y = "Average Waiting Time") +
         guides(colour = guide_legend(override.aes = list(shape = 15, size = 10))) + 
         coord_cartesian(ylim = c(0, 0.8)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)),
               legend.title = element_blank(), legend.text = element_text(size = 24), legend.key = element_blank())
)

# line plot of proportion no waiting time for each customer
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/WT_Line_Prop.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = waitTimes, aes(x = factor(customer), y = no_waiting, group = factor(schedule),
                                      colour = factor(schedule))) +
         stat_summary(fun.y = "mean", geom = "point", size = 3) +
         stat_summary(fun.y = "mean", geom = 'line', size = 1.5) +
         labs(x = "Customer", y = "Proportion with Zero Waiting Time") +
         guides(colour = guide_legend(override.aes = list(shape = 15, size = 10))) + 
         coord_cartesian(ylim = c(0, 1)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)),
               legend.title = element_blank(), legend.text = element_text(size = 24), legend.key = element_blank())
)

# arrival times table
arrivalTimes = data.frame(matrix(c(rep("Static Schedule", 15), rep("Dynamic Schedule", 15)), nrow = 30, ncol = 1))
colnames(arrivalTimes) = c("schedule")
arrivalTimes$schedule = factor(arrivalTimes$schedule, levels = c("Static Schedule", "Dynamic Schedule"))

arrivalTimes$customer = rep(as.numeric(unlist(strsplit(as.character(colnames(data)[3:17]), split = '[.]'))[seq(from = 2,
                            to = 30, by = 2)]),2)

for (i in 1:15) {
  arrivalTimes$arrival_time[i] = mean(static[,paste("AT",i,"", sep = ".")])
  arrivalTimes$arrival_time[i + 15] = mean(dynamic[,paste("AT",i,"", sep = ".")])
}

# line plot of mean arrival time for each customer
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/AT_Line.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = arrivalTimes, aes(x = factor(customer), y = arrival_time, group = factor(schedule),
                                         colour = factor(schedule))) +
         stat_summary(fun.y = "mean", geom = "point", size = 3) +
         stat_summary(fun.y = "mean", geom = 'line', size = 1.5) +
         labs(x = "Customer", y = "Average Arrival Time") +
         guides(colour = guide_legend(override.aes = list(shape = 15, size = 10))) + 
         coord_cartesian(ylim = c(0, 25)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)),
               legend.title = element_blank(), legend.text = element_text(size = 24), legend.key = element_blank())
)