library(ggplot2)
library(reshape2)

setwd("~/Documents/Scheduled-Arrivals/R\ Code")

# import data
data = read.csv(file = "../Python\ Code/Static_Output.csv", header = TRUE, sep = ",")

# select case for n = 15
varyGamma = data[data$n == 15,]

# interarrival times table varying gamma
varyGamma = melt(varyGamma[,c(2,4:17)], id = c('gamma'), na.rm = TRUE)
colnames(varyGamma) = c('gamma', 'customer', 'interarrival_time')
varyGamma$customer = 1 + as.numeric(unlist(strsplit(as.character(
                                varyGamma$customer), split = '[.]'))[seq(from = 2,
                                to = 2 * nrow(varyGamma), by = 2)])

# line plot of interarrival time for each customer varying gamma
ggsave(filename = "~/Documents/Scheduled-Arrivals/Presentation/Figures/Static_Line_Interarrival_Gamma.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = varyGamma, aes(x = factor(customer), y = interarrival_time,
                                      group = gamma, colour = gamma)) +
         stat_summary(fun.y = "mean", geom = "point", size = 6) +
         stat_summary(fun.y = "mean", geom = 'line', size = 3) +
         labs(x = "Customer Position", y = "Interarrival Time") +
         guides(color = guide_colorbar(title = expression(bold("Gamma"~(gamma)~"   ")), nbin = 1000, ticks = FALSE, barwidth = 35)) +
         scale_colour_gradient(limits = c(0.1, 0.9), breaks = (1:9)/10) +
         ylim(c(0,3)) + theme_bw() +
         theme(axis.text.x = element_text(size = 48), axis.text.y = element_text(size = 48),
               axis.title.x = element_text(face = "bold", size = 56, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 56, margin = margin(0, 20, 0, 20)),
               legend.title = element_text(size = 56), legend.text = element_text(size = 30), legend.position = "top")
         )

# select case for gamma = 0.5
varyNum = data[data$gamma == 0.5,]

# interarrival times table varying n
varyNum = melt(varyNum[,c(1,4:17)], id = c('n'), na.rm = TRUE)
colnames(varyNum) = c('n', 'customer', 'interarrival_time')
varyNum$customer = 1 + as.numeric(unlist(strsplit(as.character(
                              varyNum$customer), split = '[.]'))[seq(from = 2,
                              to = 2 * nrow(varyNum), by = 2)])

# line plot of interarrival time for each customer varying n
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Static_Line_Interarrival_Num.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = varyNum, aes(x = factor(customer), y = interarrival_time,
                                         group = n, color = n)) +
         stat_summary(fun.y = "mean", geom = "point", size = 3) +
         stat_summary(fun.y = "mean", geom = 'line', size = 1.5) +
         labs(x = "Customer Position", y = "Interarrival Time") +
         guides(color = guide_colorbar(title = "Number of Customers    ", nbin = 1000, ticks = FALSE, barwidth = 35)) +
         scale_colour_gradient(limits = c(2,15), breaks = 2:15) +
         ylim(c(0,2)) + theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)),
               legend.title = element_text(face = "bold", size = 28), legend.text = element_text(size = 24),
               legend.position = "top")
         )