library(ggplot2)
library(reshape2)

setwd("~/Documents/Scheduled-Arrivals/R\ Code")

# import data
data = read.csv(file = "../Python\ Code/Dynamic_Output.csv", header = TRUE, sep = ",")

# select case for gamma = 0.5 and total customers < 15
data = data[data$gamma == 0.5 & data$n + data$k <= 15,]

# line plot of cost for each n varying k
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Dynamic_Line_Cost_k.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = data, aes(x = factor(n), y = cost,
                                      group = k, colour = k)) +
         stat_summary(fun.y = "mean", geom = "point", size = 3) +
         stat_summary(fun.y = "mean", geom = 'line', size = 1.5) +
         labs(x = "Number to be Scheduled (n)", y = "Expected Cost of State (n,k)") +
         guides(color = guide_colorbar(title = "Number in System (k)    ", nbin = 1000, ticks = FALSE, barwidth = 35)) +
         scale_colour_gradient(limits = c(0, 15), breaks = 0:15) +
         ylim(c(0,60)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)),
               legend.title = element_text(face = "bold", size = 28), legend.text = element_text(size = 24),
               legend.position = "top")
         )
         
# line plot of cost for each k varying n
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Dynamic_Line_Cost_n.eps",
       width = 20, height = 10,
       plot =     
         ggplot(data = data, aes(x = factor(k), y = cost,
                                 group = n, colour = n)) +
           stat_summary(fun.y = "mean", geom = "point", size = 3) +
           stat_summary(fun.y = "mean", geom = 'line', size = 1.5) +
           labs(x = "Number in System (k)", y = "Expected Cost of State (n,k)") +
           guides(color = guide_colorbar(title = "Number to be Scheduled (n)    ", nbin = 1000, ticks = FALSE, barwidth = 35)) +
           scale_colour_gradient(limits = c(0, 15), breaks = 0:15) +
           ylim(c(0,60)) +
           theme_bw() +
           theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
                 axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
                 axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)),
                 legend.title = element_text(face = "bold", size = 28), legend.text = element_text(size = 24),
                 legend.position = "top")
         )

# remove case n = 0 to plot a
arrivalTimes = data[data$n > 0,]

# line plot of interarrival time for each n varying k
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Dynamic_Line_Interarrival_k.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = arrivalTimes, aes(x = factor(n), y = a,
                                 group = k, colour = k)) +
           stat_summary(fun.y = "mean", geom = "point", size = 3) +
           stat_summary(fun.y = "mean", geom = 'line', size = 1.5) +
           labs(x = "Number to be Scheduled (n)", y = "Interarrival Time for Next Customer") +
           guides(color = guide_colorbar(title = "Number in System (k)    ", nbin = 1000, ticks = FALSE, barwidth = 35)) +
           scale_colour_gradient(limits = c(0, 15), breaks = 0:15) +
           ylim(c(0,15)) +
           theme_bw() +
           theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
                 axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
                 axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)),
                 legend.title = element_text(face = "bold", size = 28), legend.text = element_text(size = 24),
                 legend.position = "top")
         )