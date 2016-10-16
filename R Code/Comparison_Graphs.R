library(ggplot2)

setwd("~/Documents/Scheduled-Arrivals/R\ Code")

# import static data
static = read.csv(file = "../Python\ Code/Static_Output.csv", header = TRUE, sep = ",")
static = static[,c("n","gamma","mu","cost")]
static$schedule = "Static Schedule"

# import dynamic data
dynamic = read.csv(file = "../Python\ Code/Dynamic_Output.csv", header = TRUE, sep = ",")
dynamic = dynamic[dynamic$k == 0 & dynamic$n >= 0 & dynamic$n <= 15, c("n","gamma","mu","cost")]
dynamic$schedule = "Dynamic Schedule"

# add case for n = 0 or n = 1 to static data frame
static = rbind(static, dynamic[dynamic$n >= 0 & dynamic$n <= 1,])
static$schedule = "Static Schedule"

# combine data frames
data = rbind(static, dynamic)
data$schedule = factor(data$schedule, levels = c("Static Schedule", "Dynamic Schedule"))

# line plot of cost for each schedule varying number of customers
ggsave(filename = "~/Documents/Scheduled-Arrivals/Thesis/Figures/Comparison_Line_Cost_Num.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = data, aes(x = factor(n), y = cost, group = factor(schedule), colour = factor(schedule))) +
         stat_summary(fun.y = "mean", geom = "point", size = 3) +
         stat_summary(fun.y = "mean", geom = 'line', size = 1.5) +
         labs(x = "Number of Customers (N)", y = "Expected Cost of Schedule") +
         guides(colour = guide_legend(override.aes = list(shape = 15, size = 10))) + 
         coord_cartesian(ylim = c(0, 15)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 24), axis.text.y = element_text(size = 24),
               axis.title.x = element_text(face = "bold", size = 28, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 28, margin = margin(0, 20, 0, 20)),
               legend.title = element_blank(), legend.text = element_text(size = 24), legend.key = element_blank())
         )

# create cost comparison data frame
static = static[,c("n","gamma","mu","cost")]
colnames(static) = c("n","gamma","mu","static")

dynamic = dynamic[,c("n","gamma","mu","cost")]
colnames(dynamic) = c("n","gamma","mu","dynamic")

costDiff = merge(static, dynamic, by = c("n", "gamma", "mu"))
costDiff$saving = 100 * (costDiff$static - costDiff$dynamic) / costDiff$static
costDiff$saving[is.na(costDiff$saving)] = 0

# line plot of cost for each schedule varying number of customers
ggsave(filename = "~/Documents/Scheduled-Arrivals/Presentation/Figures/Cost_Saving_Line_Num.eps",
       width = 20, height = 10,
       plot =
         ggplot(data = costDiff, aes(x = factor(gamma), y = saving, group = n, colour = n)) +
         stat_summary(fun.y = "mean", geom = "point", size = 6) +
         stat_summary(fun.y = "mean", geom = 'line', size = 3) +
         labs(x = expression(bold("Gamma"~(gamma))), y = expression(bold("Cost Saving"~(Delta~C)))) +
         guides(color = guide_colorbar(title = "Number of Customers (N)    ", nbin = 1000, ticks = FALSE, barwidth = 40)) +
         scale_colour_gradient(limits = c(0,15), breaks = 0:15) +
         coord_cartesian(ylim = c(0, 15)) +
         theme_bw() +
         theme(axis.text.x = element_text(size = 48), axis.text.y = element_text(size = 48),
               axis.title.x = element_text(face = "bold", size = 56, margin = margin(20, 0, 20, 0)),
               axis.title.y = element_text(face = "bold", size = 56, margin = margin(0, 20, 0, 20)),
               legend.title = element_text(face = "bold", size = 56), legend.text = element_text(size = 30),
               legend.position = "top")
)